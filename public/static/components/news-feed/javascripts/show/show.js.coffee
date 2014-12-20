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
    markup.push("<h2>Fuckin-A</h2>")

    for post, index in @feed
      markup.push( "<div class='news-feed-post'>
                      <img src='#{post.image}' />
                      <div>#{post.title}</div>
                      <div>#{post.author}</div>
                      <div>#{post.date}</div>
                      <div>#{post.description}</div>
                      <div>#{post.text}</div>
                    </div>" )
      
    $('.news-feed-widget').append(markup.join(''))



      


  


        

    

