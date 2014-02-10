
window.initTweets = (tweetOptions) ->
 $.ajax(
    url: "https://mobile.twitter.com/" + tweetOptions.id
    dataType: "html"
    type: "GET"
  ).done (data) ->
    tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray()
    avatar = $(".avatar:lt(1) img", data.results[0])

    composeTweet(data, tweets, avatar)

composeTweet = (tweetOptions, tweets, avatar) ->
  composedTweets = []

  tweets.forEach (tweet) ->
    timestamp = $(tweet).find(".timestamp")
    user = timestamp.find("a").attr("href")
    time = timestamp.text()
    avatarUrl = $(avatar[0]).attr('src')
    url = "http://www.twitter.com" + user
    text = composeAtReply(tweet) + $(tweet).find(".tweet-text p").html()

    composedTweets.push(tweetTemplate(avatarUrl, text, url, time))

  $('.tweet-avatar').hide() unless tweetOptions.avatar is true
  $('.tweet-list').append(composedTweets)

tweetTemplate = (avatar, text, url, time) ->
  "<li><img class='tweet-avatar' src='" + avatar + "'/>
  <span class='tweet-text'> " + text +
  "<a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a></span></li>"

composeAtReply = (tweet) ->
  atReplyHTML = $(tweet).find(".tweet-text .twitter-atreply")

  replyTemplates = []
  atReplyHTML.each (reply) ->
    fullReply = atReplyHTML.get(reply)
    replyUrl = 'http://www.twitter.com' + $(fullReply).attr("href")
    replyText = $(fullReply).text()
    template = "<a href='" + replyUrl + "' target='_blank'>" + replyText + "</a> "
    replyTemplates.push(template)

  replyTemplates.join(" ")

$ ->
  tweetOptions = JSON.parse($('.twitter-feed .config:first').html())
  initTweets(tweetOptions)

