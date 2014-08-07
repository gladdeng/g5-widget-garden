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

  # Twitter feed setup
  if feedVars.twitter_username.length > 1
    new tweetInitializer(feedVars)

  # Blog feed setup
  # 10 chars is probably a safe bare minimum for a valid blog feed
  if feedVars.feed_url.length > 10
    blogConfig = new window.BlogConfig(feedVars)
    new window.BlogInterface($("#blog-feed .feed"), blogConfig)
  
  # Facebook Setup
  # https://www.facebook.com/feeds/page.php?id=255110695512&format=json
  facebookFeed = new facebookInitializer(feedVars)

  # Google+ Setup


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

    feedTab = " <a class='feed-switch' id='feed-switch-blog' href='#blog-feed' title='Show Blog Feed'>
                  <svg version='1.1' id='Layer_2' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' width='30px' height='30px' viewBox='0 0 200 200' enable-background='new 0 0 200 200' xml:space='preserve'>
                  <path stroke-width='40' d='M0,22'/>
                  <path stroke-width='40' d='M111,196.48C111,136.52,61.354,88,0,88'/>
                  <path stroke-width='40' d='M181,196.48'/>
                  <circle cx='27.5' cy='169.5' r='24.5'/>
                  <path stroke-width='40' d='M181,196.48C181,100.039,100.045,22,0,22'/>
</svg>
                </a>"
    $('.feed-switcher').append(feedTab)
     
    feedBlock = " <div id='blog-feed' class='blog-feed feed-section' style='display: none;'>
                    <ul class='h-feed feed'>#{feedList}</ul>
                  </div>"

    $('.social-feed').append(feedBlock)
    new tabListener('#feed-switch-blog', '#blog-feed')


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

    twitterTab = "<a class='feed-switch' id='feed-switch-twitter' href='#twitter-feed' title='Show Tweets'>
                    <svg enable-background='new 0 0 512 512' height='40' style='max-width:100%; max-height:100%;' version='1.1' viewBox='0 0 512 512' width='40' x='0px' xmlns='http://www.w3.org/2000/svg' y='0px'><path alt='twitter' class='social-feed-icon twitter-social-feed-icon' d='M462,128.223c-15.158,6.724-31.449,11.269-48.547,13.31c17.449-10.461,30.854-27.025,37.164-46.764 c-16.333,9.687-34.422,16.721-53.676,20.511c-15.418-16.428-37.386-26.691-61.698-26.691c-54.56,0-94.668,50.916-82.337,103.787 c-70.25-3.524-132.534-37.177-174.223-88.314c-22.142,37.983-11.485,87.691,26.158,112.85c-13.854-0.438-26.891-4.241-38.285-10.574 c-0.917,39.162,27.146,75.781,67.795,83.949c-11.896,3.237-24.926,3.978-38.17,1.447c10.754,33.58,41.972,58.018,78.96,58.699 C139.604,378.282,94.846,390.721,50,385.436c37.406,23.982,81.837,37.977,129.571,37.977c156.932,0,245.595-132.551,240.251-251.435 C436.339,160.061,450.668,145.174,462,128.223z'></path></svg>
                  </a>"
    $('.feed-switcher').append(twitterTab)

    twitterBlock = "<div id='twitter-feed' class='twitter-feed feed-section' style='display:none;'>
                      <ul class='tweet-list'>
                        #{composedTweets.join('')}
                      </ul>
                      <a class='btn' href='http://www.twitter.com/#{feedVars.twitter_username}' href='#' target='_blank'>Read All</a>
                    </div>"

    $('.social-feed').append(twitterBlock)
    new tabListener('#feed-switch-twitter', '#twitter-feed')

  tweetTemplate = (avatar, userName, userUrl, text, url) ->
    " <li>
        <span class='tweet-avatar'><img src='#{avatar}'/></span>
        <a href='#{url}' class='tweet-name' target='_blank'> #{userName} says:</a>
        <span class='tweet-text'> #{text}</span>
      </li>"

# FACEBOOK UTILITIES
# *******************

class facebookInitializer
  constructor: (feedVars) ->
    return getpage feedVars
    
  getpage = (feedVars) ->
    $.ajax
      url: "http://localhost:4000/facebook_feed/#{feedVars.facebook_page_id}"
      dataType: 'json'
      success: (data) =>
        new facebookFeedBuilder(feedVars, data);

class facebookFeedBuilder
  constructor: (feedVars, dataFeed) ->
    facebookTab = " <a class='feed-switch' id='feed-switch-facebook' href='#facebook-feed' title='Show Facebook Feed'>
                      <svg enable-background='new 0 0 512 512' height='40' style='max-width:100%; max-height:100%;' version='1.1' viewBox='0 0 512 512' width='40' x='0px' xmlns='http://www.w3.org/2000/svg' y='0px'><path alt='facebook' class='social-feed-icon facebook-social-feed-icon' d='M204.067,184.692h-43.144v70.426h43.144V462h82.965V254.238h57.882l6.162-69.546h-64.044 c0,0,0-25.97,0-39.615c0-16.398,3.302-22.89,19.147-22.89c12.766,0,44.896,0,44.896,0V50c0,0-47.326,0-57.441,0 c-61.734,0-89.567,27.179-89.567,79.231C204.067,174.566,204.067,184.692,204.067,184.692z'></path></svg>
                    </a>"
    $('.feed-switcher').append(facebookTab)

    facebookFeedList = []

    for post, index in dataFeed.data
      break if (index + 1) > feedVars.facebook_post_limit
      facebookFeedList.push(postTemplate(post))

    facebookBlock = "<div id='facebook-feed' class='facebook-feed feed-section' style='display:none;'>
                      <ul class='tweet-list'>
                        #{facebookFeedList.join('')}
                      </ul>
                    </div>"

    $('.social-feed').append(facebookBlock)

    new tabListener('#feed-switch-facebook', '#facebook-feed')


  postTemplate = (post) ->
    " <li>
        <div class='facebook-name tweet-name'>#{post.from.name} said:</div>
        <div class='facebook-post'>#{post.message}</div>
      </li>"

# GOOGLE+ UTILITIES
# *******************


# GENERAL UTILITIES
# *******************

class tabListener
  constructor: (tab, block) ->
    $('.social-feed').on 'click', tab, (e) ->
      $('.social-feed .feed-switch').removeClass('active')
      $(this).addClass('active')

      $('.feed-section').css('display', 'none')

      $(block).css('display', 'block')
      # feed = $(this).attr('href')
      # $('#blog-feed, #twitter-feed').hide()
      # $(feed).show()
      return false

    if $('.feed-switcher a').length == 1
      $(tab).addClass('active')
      $(block).css('display', 'block')


    


