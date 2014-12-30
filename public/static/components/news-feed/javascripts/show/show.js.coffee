$ ->
  configs = JSON.parse($('#news-feed-config').html())

  feedURL = "#{configs.newsServiceDomain}/locations/#{configs.locationURN}/news_feed.json"
  feedSource = new NewsFeedSource(feedURL)
  $(feedSource).bind("feedReady", (event) =>
    new NewsFeedBuilder(configs, feedSource.feed)
    toggleListener = new ToggleListener(configs, feedSource.feed)
    # ADD LOGIC HERE TO DETERMINE LISTENER TYPE
    toggleListener.fullViewListener())
    
  feedSource.getFeed()

class NewsFeedBuilder
  constructor: (@configs, @feed) ->
    @populateFeed()

  populateFeed: () ->
    postCount = parseInt(@configs.numberOfPosts)
    postCount = 5 if isNaN(postCount)

    websitePosts = @feed[0...postCount]
    markup = []

    for post, index in websitePosts
      markup.push( "<div class='news-feed-post'>
                      #{@toggleMarkup(post, index)}
                      #{@detailsMarkup(post)}
                      <div class='post-body'>#{post.text}</div>
                      <a class='post-toggle post-expand' href='#' data-post-index='#{index}'>Read More</a>
                      <a class='post-toggle post-collapse' href='#'>Hide This</a>
                    </div>" )
      
    $('.news-feed-widget').append(markup.join(''))

  toggleMarkup: (post, index) ->
    toggle  = "<a class='post-toggle' href='#' data-post-index='#{index}'>"
    toggle += "  <img src='#{post.image}' />" unless post.image == ""
    toggle += "  <h3 class='post-title'>#{post.title}</h3>" unless post.title == ""
    toggle += "</a>"

  detailsMarkup: (post) ->
    details  = "<span class='post-date'>#{post.pretty_date}</span>" unless post.title == ""
    details += "<span>|</span><span class='post-author'>by #{post.author}</span>" unless post.author == ""
    details += "<div class='post-description'>#{post.description}</div>" unless post.description == ""

class SingleArticleView
  constructor: (@postIndex, @configs, @feed) ->
    # @clearAllPosts()
    @buildSelectedPost()

  clearAllPosts: () ->
    $(".news-feed-single-post, .news-feed-post").remove()

  buildSelectedPost: () ->
    post = @feed[@postIndex]
    postMarkup = "<div class='news-feed-single-post'>
                    <img src='#{post.image}' />
                    <h3 class='post-title'>#{post.title}</h3>
                    <span class='post-date'>#{post.pretty_date}</span>
                    <span>|</span><span class='post-author'>by #{post.author}</span>
                    <div class='post-body'>#{post.text}</div>
                    <div>
                      <a href='#' data-post-index='#{@postIndex - 1}' class='post-toggle previous-post'><span>Previous</span></a>
                      <a href='#' class='all-posts'><span>All News</span></a>
                      <a href='#' data-post-index='#{@postIndex + 1}' class='post-toggle next-post'><span>Next</span></a>
                    </div>
                  </div>"

    $('.news-feed-widget').append(postMarkup)

    toggleListener = new ToggleListener(@configs, @feed)
    toggleListener.fullViewListener()
    toggleListener.listViewListener()
    
class ToggleListener
  constructor: (@configs, @feed) ->

  basicListener: () ->
    $('.post-toggle').click ->
      $(this).parent().toggleClass("active-post")
      false

  fullViewListener: () ->
    that = this
    $('.post-toggle').click ->
      postIndex = $(this).data("post-index")
      that.clearAllPosts()
      new SingleArticleView(postIndex, that.configs, that.feed)
      false

  listViewListener: () ->
    that = this
    $('.all-posts').click ->
      that.clearAllPosts()
      new NewsFeedBuilder(that.configs, that.feed)
      toggleListener = new ToggleListener(that.configs, that.feed)
      toggleListener.fullViewListener()
      false

  clearAllPosts: () ->
    $(".news-feed-single-post, .news-feed-post").remove()

    $('html, body').animate({
      scrollTop: $("#news-feed-top").offset().top
    }, 420)

class NewsFeedSource
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
