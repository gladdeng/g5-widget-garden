
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
  twitterUrl = "http://www.twitter.com"
  composedTweets = []

  tweets.forEach (tweet) ->
    timestamp = $(tweet).find(".timestamp")
    user = timestamp.find("a").attr("href")
    time = timestamp.text()
    avatarUrl = $(avatar[0]).attr('src')
    url = twitterUrl + user
    tweetHtml = $(tweet).find(".tweet-text")
    replyHtml = tweetHtml.find(".twitter-atreply")

    # Handle Retweets
    if $(tweet).has('.context').length > 0
      userInfo = $(tweet).find('.tweet-header')
      avatarUrl = userInfo.find(".avatar img").attr("src")

    # Handle Replies
    replyHtml.each ->
      $(this).attr("href", twitterUrl + $(this).attr("href"))

    composedTweets.push(tweetTemplate(avatarUrl, tweetHtml.html(), url, time))

  $('.tweet-avatar').hide() unless tweetOptions.avatar is true
  $('.tweet-list').append(composedTweets)

tweetTemplate = (avatar, text, url, time) ->
  "<li><img class='tweet-avatar' src='" + avatar + "'/>
  <span class='tweet-text'> " + text +
  "<a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a></span></li>"

$ ->
  tweetOptions = JSON.parse($('.twitter-feed .config:first').html())
  initTweets(tweetOptions)

