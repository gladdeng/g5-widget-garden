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
                      <a class='post-toggle' href='#'>
                        <img src='#{post.image}' />
                        <div class='post-title'>#{post.title}</div>
                      </a>
                      <div class='post-date'>#{post.date}</div>
                      <div class='post-author'>#{post.author}</div>
                      <div class='post-description'>#{post.description}</div>
                      <div class='post-body'>#{post.text}</div>
                      <a class='post-toggle post-expand' href='#'>Read More</a>
                      <a class='post-toggle post-collapse' href='#'>Less</a>
                    </div>" )
      
    $('.news-feed-widget').append(markup.join(''))

class ToggleListener
  constructor: (@configs) ->
    @basicListener()

  basicListener: () ->
    $('.post-toggle').click ->
      $(this).parent().toggleClass("active-post")
      false



      


  


        

    

