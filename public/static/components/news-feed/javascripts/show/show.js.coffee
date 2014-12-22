$ ->
  configs = JSON.parse($('#news-feed-config').html())
  $.ajax
    url: "#{configs.newsServiceDomain}/locations/#{configs.locationURN}/news_feed.json"
    dataType: 'json'
    success: (data) =>
      new NewsFeedBuilder(configs, data)
      new ToggleListener(configs)

class NewsFeedBuilder
  constructor: (@configs, @feed) ->
    @populateFeed()

  populateFeed: () ->
    markup = []

    for post, index in @feed
      markup.push( "<div class='news-feed-post'>
                      #{@toggleMarkup(post)}
                      #{@detailsMarkup(post)}
                      <div class='post-body'>#{post.text}</div>
                      <a class='post-toggle post-expand' href='#'>Read More</a>
                      <a class='post-toggle post-collapse' href='#'>Hide This</a>
                    </div>" )
      
    $('.news-feed-widget').append(markup.join(''))

  toggleMarkup: (post) ->
    toggle  = "<a class='post-toggle' href='#'>"
    toggle += "  <img src='#{post.image}' />" unless post.image == ""
    toggle += "  <h3 class='post-title'>#{post.title}</h3>" unless post.title == ""
    toggle += "</a>"

  detailsMarkup: (post) ->
    details  = "<span class='post-date'>#{post.pretty_date}</span>" unless post.title == ""
    details += "<span>|</span><span class='post-author'>by #{post.author}</span>" unless post.author == ""
    details += "<div class='post-description'>#{post.description}</div>" unless post.description == ""

class ToggleListener
  constructor: (@configs) ->
    @basicListener()

  basicListener: () ->
    $('.post-toggle').click ->
      $(this).parent().toggleClass("active-post")
      false



      


  


        

    

