$ ->
  configs = JSON.parse($('#news-feed-config').html())
  $.ajax
    url: "#{configs.newsServiceDomain}/locations/#{configs.locationURN}/news_feed.json"
    dataType: 'json'
    success: (data) =>
      new NewsFeedBuilder(configs, data)

class NewsFeedBuilder
  constructor: (@configs, @feed) ->
    @populateFeed()

  populateFeed: () ->
    markup = []

    for post, index in @feed
      markup.push( "<div class='news-feed-post'>
                      <div class='post-summary'>
                        <img src='#{post.image}' />
                        <div>#{post.title}</div>
                        <div>#{post.date}</div>
                        <div>#{post.author}</div>
                        <div>#{post.description}</div>
                      </div>
                      <div class='post-body'>#{post.text}</div>
                    </div>" )
      
    $('.news-feed-widget').append(markup.join(''))



      


  


        

    

