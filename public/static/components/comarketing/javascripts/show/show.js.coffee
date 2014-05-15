
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
    userName = $(tweet).find('.fullname').html()
    time = timestamp.text()
    avatarUrl = $(avatar[0]).attr('src')
    userUrl = twitterUrl + '/' + userName
    url = twitterUrl + user
    tweetHtml = $(tweet).find(".tweet-text")
    replyHtml = tweetHtml.find(".twitter-atreply")

    # Handle Retweets
    if $(tweet).has('.context').length > 0
      userInfo = $(tweet).find('.tweet-header')
      avatarUrl = userInfo.find(".avatar img").attr("src")
      userName = userInfo.find(".fullname").html()

    # Handle Replies
    replyHtml.each ->
      $(this).attr("href", twitterUrl + $(this).attr("href"))

    composedTweets.push(tweetTemplate(avatarUrl, userName, userUrl, tweetHtml.html(), url, time))

  $('.tweet-avatar').hide() unless tweetOptions.avatar is true
  $('.tweet-list').append(composedTweets)

tweetTemplate = (avatar, userName, userUrl, text, url, time) ->
  "<li><img class='tweet-avatar' src='" + avatar + "'/>
  <a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a>
  <a href=" + userUrl + " class='tweet-name' target='_blank'>" + userName + "</a>
  <span class='tweet-text'> " + text +
  "</span></li>"

$ ->
  tweetOptions = JSON.parse($('.twitter-feed .config:first').html())
  initTweets(tweetOptions)

