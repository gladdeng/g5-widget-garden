$ ->
  configs = JSON.parse($('#news-feed-config').html())
  newsFeed = new FeedSlurper(configs)


class FeedSlurper
  constructor: (@configs) ->
    $.ajax
      url: "#{@configs.newsServiceDomain}/locations/#{@configs.locationURN}/news_feed.json"
      dataType: 'json'
      success: (data) =>
        alert "made it"
        debugger

