$ ->
  tweetOptions = JSON.parse($('#twitter-feed-config:first').html())
  tweetOptions.template = tweetOptions.template.replace(/\\/g, "")
  getTwitters('tweets', tweetOptions)