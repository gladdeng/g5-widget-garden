# Start Here: Get widget configs, build
# initial view, and set up click listener
# ******************************************

$ ->
  configs = JSON.parse($('#mini-news-feed-config').html())

  feedURL = "#{configs.newsServiceDomain}/locations/#{configs.locationURN}/news_feed.json"
  feedSource = new MiniNewsFeedSource(feedURL)
  $(feedSource).bind("feedReady", (event) =>
    new NewsLinkBuilder(configs, feedSource.feed) )

  feedSource.getFeed()
  new MiniNewsFeedWidthChecker()


# Build out markup for posts links
# ******************************************

class NewsLinkBuilder
  constructor: (@configs, @feed) ->
    @populateFeed()

  populateFeed: () ->
    postCount = parseInt(@configs.numberOfPosts)
    postCount = 5 if isNaN(postCount)

    websitePosts = @feed[0...postCount]
    markup = []

    for post, index in websitePosts
      markup.push( "<a class='news-item-link' href='#{@configs.newsPagePath}?article-index=#{index}' data-post-index='#{index}'>
                      <img src='#{post.image}' />
                      <h3 class='post-title'>#{post.title}</h3>
                      <span class='post-date'>#{post.pretty_date}</span>
                      <span>|</span>
                      <span class='post-author'>by #{post.author}</span>
                      <div class='post-description'>#{post.description}</div>
                    </a>" )
      
    $('.mini-news-feed-widget').append(markup.join(''))

# Get news feed from service or session storage
# ******************************************

class MiniNewsFeedSource
  constructor: (@url) ->
    
  getFeed: ->
    if @feedFromStorage()
      $(this).trigger("feedReady")
    else
      @fetch()

  fetch: ->
    $.ajax
      url: @url
      dataType: 'json'
      success: (data, status, xhr) =>
        @feed = data
        @storeFeed()
        $(this).trigger("feedReady")
      error: (xhr, status, error) =>

  feedFromStorage: ->
    try
      @feed = JSON.parse(sessionStorage.getItem(@url))
    catch
      null

  storeFeed: ->
    try
      sessionStorage.setItem(@url, JSON.stringify(@feed))
    catch
      null

# Pseudo Media Query
# ******************************************

class MiniNewsFeedWidthChecker
  constructor: () ->
    @applyWidthClasses()

    $( window ).resize () =>
      @applyWidthClasses()

  applyWidthClasses: () ->
    container = $("#mini-news-feed-widget")
    width = container.width()

    if width <= 460
      container.removeClass("wide").addClass("narrow")
    else
      container.removeClass("narrow").addClass("wide")
      