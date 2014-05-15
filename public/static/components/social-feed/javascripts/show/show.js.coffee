$ ->

  # Get feed config options
  blogVars = JSON.parse($('#blog-config').html())
  twitterVars = JSON.parse($('#twitter-config').html())

  # Blog feed setup
  blogConfig = new window.BlogConfig(blogVars)
  new window.BlogInterface($("#blog-feed .feed"), blogConfig)

  # Twitter feed setup
  initTweets(twitterVars)

  # Set up tabs
  if blogVars.feedUrl != '' && twitterVars.id != ''
    $('#twitter-feed').hide()

    $('.social-feed').on 'click', '.feed-switch', (e) ->
      $('.social-feed .feed-switch').removeClass('active')
      $(this).addClass('active')
      feed = $(this).attr('href')
      $('#blog-feed, #twitter-feed').hide()
      $(feed).show()
      return false



class window.BlogConfig
  constructor: (config) ->
    {@feedUrl, @feedTitle, @showAuthor, @showEntrySummary, @showDate, @entriesToShow} = config

class BlogFetcher
  constructor: (@url) ->

  fetch: ->
    $.ajax
      url: 'http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=3&callback=?&q=' + encodeURIComponent(@url)
      dataType: 'json'
      success: (data) =>
        @feed = data.responseData.feed
        $(this).trigger("feedReady")

class window.BlogInterface
  constructor: (@list, @config) ->
    fetcher = new BlogFetcher(@config.feedUrl)
    $(fetcher).bind("feedReady", (event) => @updateDom(event))
    fetcher.fetch()

   updateDom: (event) ->
     feed = event.currentTarget.feed
     @list.before("<h2 class=\"title\">#{@config.feedTitle}</h2>") if @config.feedTitle?
     for entry in feed.entries
       jli = $('<li class="h-entry hentry" itemscope itemtype="http://schema.org/BlogPosting">')
       innerText = "<a class='p-name entry-title u-url url' href=\"#{entry.link}\" target=\"_blank\" itemprop='url'><span itemprop='headline'>#{entry.title}</span></a><br />"
       innerText += "<span class=\"dt-published published date\" itemprop='datePublished'>#{@formatDate(entry.publishedDate)}</span>" if @config.showDate
       innerText += "<div class='p-summary summary' itemprop='description'>#{entry.contentSnippet}</div>" if @config.showEntrySummary
       innerText += "<div class='p-author author' itemprop='author'>Posted By: #{entry.author}</div>" if @config.showAuthor
       jli.append(innerText)
       @list.append(jli)

  formatDate: (postDate) ->
    date = new Date(Date.parse(postDate))
    day = date.getDate()
    month = date.getMonth()
    year = date.getFullYear()
    "#{day}/#{month}/#{year}"


window.initTweets = (twitterVars) ->
 $.ajax(
    url: "https://mobile.twitter.com/" + twitterVars.id
    dataType: "html"
    type: "GET"
  ).done (data) ->
    tweets = $(".timeline .tweet:lt(" + twitterVars.count + ")", data.results[0]).toArray()
    avatar = $(".avatar:lt(1) img", data.results[0])

    composeTweet(data, tweets, avatar)

composeTweet = (twitterVars, tweets, avatar) ->
  twitterUrl = "http://www.twitter.com"
  composedTweets = []

  tweets.forEach (tweet) ->
    timestamp = $(tweet).find(".timestamp")
    user = timestamp.find("a").attr("href")
    userName = $(tweet).find('.fullname').html()
    time = timestamp.text()
    avatarUrl = $(avatar[0]).attr('src')
    userUrl = twitterUrl + '/' + userName
    url = twitterUrl + user
    tweetHtml = $(tweet).find(".tweet-text")
    replyHtml = tweetHtml.find(".twitter-atreply")

    # Handle Retweets
    if $(tweet).has('.context').length > 0
      userInfo = $(tweet).find('.tweet-header')
      avatarUrl = userInfo.find(".avatar img").attr("src")
      userName = userInfo.find(".fullname").html()

    # Handle Replies
    replyHtml.each ->
      $(this).attr("href", twitterUrl + $(this).attr("href"))

    composedTweets.push(tweetTemplate(avatarUrl, userName, userUrl, tweetHtml.html(), url, time))

  $('#twitter-feed .tweet-avatar').hide() unless twitterVars.avatar is true
  $('#twitter-feed .tweet-list').append(composedTweets)

tweetTemplate = (avatar, userName, userUrl, text, url, time) ->
  "<li><img class='tweet-avatar' src='" + avatar + "'/>
  <a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a>
  <a href=" + userUrl + " class='tweet-name' target='_blank'>" + userName + "</a>
  <span class='tweet-text'> " + text +
  "</span></li>"
