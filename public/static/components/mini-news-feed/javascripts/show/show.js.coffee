# Start Here: Get widget configs, build
# initial view, and set up click listener
# ******************************************

$ ->
  configs = JSON.parse($('#mini-news-feed-config').html())

  feedURL = "#{configs.newsServiceDomain}/locations/#{configs.locationURN}/news_feed.json"
  feedSource = new MiniNewsFeedSource(feedURL)
  $(feedSource).bind("feedReady", (event) =>
    new NewsFeedBuilder(configs, feedSource.feed) )

  feedSource.getFeed()
  new MiniNewsFeedWidthChecker()


# Build out markup for initial list of posts
# ******************************************

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
                      #{@bottomToggles(index)}
                    </div>" )
      
    $('.mini-news-feed-widget').append(markup.join(''))

  toggleMarkup: (post, index) ->
    toggle  = "<a class='post-toggle' href='#' data-post-index='#{index}'>"
    toggle += "  <img src='#{post.image}' />" unless post.image == ""
    toggle += "  <h3 class='post-title'>#{post.title}</h3>" unless post.title == ""
    toggle += "</a>"

  bottomToggles: (index) ->
    toggles  = "<a class='post-toggle post-expand' href='#' data-post-index='#{index}'>Read More</a>"
    toggles += "<a class='post-toggle post-collapse' href='#'>Hide This</a>" if @configs.uiType != "full-page"
    toggles

  detailsMarkup: (post) ->
    details  = "<span class='post-date'>#{post.pretty_date}</span>" unless post.title == ""
    details += "<span>|</span><span class='post-author'>by #{post.author}</span>" unless post.author == ""
    details += "<div class='post-description'>#{post.description}</div>" unless post.description == ""
    details

# Build markup for selected item
# ******************************************


# Choose type of listener based on UI type
# ******************************************
    
# class ToggleListener
#   constructor: (@configs, @feed) ->
#     @selectedArticle = new QueryParameter("article-index").value()
    
#   basicListener: () ->
#     $('.post-toggle').click ->
#       $(this).parent().toggleClass("active-post")
#       false

#   fullViewListener: () ->
#     that = this
#     $('.post-toggle').click ->
#       postIndex = $(this).data("post-index")
#       that.clearAllPosts()
#       singleArticleView = new SingleArticleView(postIndex, that.configs, that.feed)
#       singleArticleView.buildSelectedPost()
#       false

#   listViewListener: () ->
#     that = this
#     $('.all-posts').click ->
#       that.clearAllPosts()
#       new NewsFeedBuilder(that.configs, that.feed)
#       toggleListener = new ToggleListener(that.configs, that.feed)
#       toggleListener.fullViewListener()
#       false

#   clearAllPosts: () ->
#     $(".news-feed-single-post, .news-feed-post").remove()

#     $('html, body').animate({
#       scrollTop: $("#news-feed-top").offset().top
#     }, 420)

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

# # Find a query param if it exists
# # ******************************************

# class QueryParameter
#   constructor: (@param) ->

#   value: () ->
#     name = @param.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
#     regex = new RegExp("[\\?&]#{name}=([^&#]*)")
#     results = regex.exec(location.search);
#     if results == null
#       false
#     else 
#       decodeURIComponent(results[1].replace(/\+/g, " "))
