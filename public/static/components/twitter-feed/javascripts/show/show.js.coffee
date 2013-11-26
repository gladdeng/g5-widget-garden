$ ->
  tweetOptions = JSON.parse($('#twitter-feed-config:first').html())

  $.ajax(
    url: "https://mobile.twitter.com/" + tweetOptions.id
    dataType: "html"
    type: "GET"
  ).done (data) ->
    tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray()
    avatar = $(".avatar:lt(1) img", data.results[0])

    tweets.forEach (tweet) ->
      tweetText = $(tweet).find(".tweet-text p").text()
      tweetTimestamp = $(tweet).find(".timestamp")
      tweetTime = tweetTimestamp.text()
      tweetAvatar = $(avatar[0]).attr('src')
      tweetUrl = "http://www.twitter.com" + tweetTimestamp.find("a").attr("href")

      tweetTemplate = "<img class='tweet-avatar' src='" + tweetAvatar + "'/> <span class='tweet-text'>" + tweetText +
      "<a href=" + tweetUrl + " class='tweet-date' target='_blank'>" + tweetTime + " ago</a></span>"

      $('.tweet-avatar').hide() unless tweetOptions.avatar is true
      $('.tweet-list').append(tweetTemplate)

