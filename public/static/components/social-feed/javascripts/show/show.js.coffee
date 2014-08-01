$ ->
  # Random TODO's:
  # * play defense on show_entry_summary and entries_to_show in case we get bad inputs
  # * Refactor so an arbitrary number and combo of feeds can be used
  # * Move check on feed_url into utilities
  # * Move the check on twitter_username into utilities
  # * add display:none logic that's smart about the first and subsequent tabs
  # *
  # *

  # Get social feed config options
  feedVars = JSON.parse($('#social-feed-config').html())

  # Blog feed setup
  # 10 chars is probably a safe bare minimum for a valid blog feed
  if feedVars.feed_url.length > 10
    blogConfig = new window.BlogConfig(feedVars)
    new window.BlogInterface($("#blog-feed .feed"), blogConfig)
  
  # Twitter feed setup
  if feedVars.twitter_username.length > 1
    new tweetInitializer(feedVars)

  # Facebook Setup

  # Google+ Setup

  # Set up tabs
  if feedVars.feed_url != '' && feedVars.twitter_username != ''
    $('#blog-feed').hide()

    $('.social-feed').on 'click', '.feed-switch', (e) ->
      $('.social-feed .feed-switch').removeClass('active')
      $(this).addClass('active')
      feed = $(this).attr('href')
      $('#blog-feed, #twitter-feed').hide()
      $(feed).show()
      return false

# BLOG FEED UTILITIES
# *******************
class window.BlogConfig
  constructor: (config) ->
    {@feed_url, @feedTitle, @showAuthor, @show_entry_summary, @entries_to_show} = config

class BlogFetcher
  constructor: (@url) ->
    
  fetch: ->
    $.ajax
      url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=3&callback=?&q=' + encodeURIComponent(@url)
      dataType: 'json'
      success: (data) =>
        @feed = data.responseData.feed
        $(this).trigger("feedReady")

class window.BlogInterface
  constructor: (@list, @config) ->
    fetcher = new BlogFetcher(@config.feed_url)
    $(fetcher).bind("feedReady", (event) => @updateDom(event))
    fetcher.fetch()

  updateDom: (event) ->
    feed = event.currentTarget.feed
    feedList = ""

    for entry in feed.entries
      feedEntry = '<li class="h-entry hentry" itemscope itemtype="http://schema.org/BlogPosting">'
      innerText = " <a class='p-name entry-title u-url url' href='#{entry.link}' target='_blank' itemprop='url'>
                      <span itemprop='headline'>#{entry.title}</span>
                    </a>
                    <br /> "
      if @config.show_entry_summary
        innerText += "<p class='p-summary summary' itemprop='description'>#{entry.contentSnippet}</p>"
      if @config.showAuthor
        innerText += "<p class='p-author author' itemprop='author'>Posted By: #{entry.author}</p>"

      feedEntry += "#{innerText}</li>"
      feedList  += feedEntry

    feedTab = '<a class="feed-switch" id="feed-switch-blog" href="#blog-feed" title="Show Blog Feed">Show Blog Feed</a>'
    $('.feed-switcher').append(feedTab)
     
    feedBlock = " <div id='blog-feed' class='blog-feed feed-section' style='display: none;'>
                    <ul class='h-feed feed'>#{feedList}</ul>
                  </div>"

    $('.social-feed').append(feedBlock)


#TWITTER UTILITIES
# *******************
class tweetInitializer
  constructor: (feedVars) ->
    $.ajax(
      url: "https://mobile.twitter.com/" + feedVars.twitter_username
      dataType: "html"
      type: "GET"
    ).done (data) ->
      tweets = $(".timeline .tweet:lt(" + feedVars.tweet_count + ")", data.results[0]).toArray()
      avatar = $(".avatar:lt(1) img", data.results[0])

      new tweetBuilder(data, tweets, avatar)


class tweetBuilder
  constructor: (feedVars, tweets, avatar) ->
    twitterUrl = "http://www.twitter.com"
    composedTweets = []

    tweets.forEach (tweet) ->
      timestamp = $(tweet).find(".timestamp")
      user = timestamp.find("a").attr("href")
      avatarUrl = $(avatar[0]).attr('src')
      userName = $(tweet).find('.fullname').html()
      userUrl = twitterUrl + '/' + feedVars.twitter_username
      url = twitterUrl + user
      tweetHtml = $(tweet).find(".tweet-text")
      replyHtml = tweetHtml.find(".twitter-atreply")

      # Handle Retweets
      if $(tweet).has('.context').length > 0
        userInfo = $(tweet).find('.tweet-header')
        avatarUrl = userInfo.find(".avatar img").attr("src")
        userName = userInfo.find(".fullname").html()

      if feedVars.display_avatar is false
        avatarUrl = 'https://widgets.g5dxm.com/social-feed/icon-speech.png'

      # Handle Replies
      replyHtml.each ->
        $(this).attr("href", twitterUrl + $(this).attr("href"))

      composedTweets.push(tweetTemplate(avatarUrl, userName, userUrl, tweetHtml.html(), url))

    twitterTab = '<a class="feed-switch active" id="feed-switch-twitter" href="#twitter-feed" title="Show Tweets">Show Twitter Feed</a>'
    $('.feed-switcher').append(twitterTab)

    twitterBlock = "<div id='twitter-feed' class='twitter-feed feed-section'>
                      <ul class='tweet-list'>
                        #{composedTweets.join('')}
                      </ul>
                      <a class='btn' href='http://www.twitter.com/#{feedVars.twitter_username}' href='#' target='_blank'>Read All</a>
                    </div>"

    $('.social-feed').append(twitterBlock)



  tweetTemplate = (avatar, userName, userUrl, text, url) ->
    " <li>
        <span class='tweet-avatar'><img src='#{avatar}'/></span>
        <a href='#{url}' class='tweet-name' target='_blank'> #{userName} says:</a>
        <span class='tweet-text'> #{text}</span>
      </li>"

# FACEBOOK UTILITIES
# *******************


# GOOGLE+ UTILITIES
# *******************