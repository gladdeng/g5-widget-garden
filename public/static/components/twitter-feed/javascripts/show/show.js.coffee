$ ->
  tweetOptions = JSON.parse($('#twitter-feed-config:first').html())

  $('.tweet-avatar').hide() unless tweetOptions.avatar is true

  $.ajax(
    url: "https://mobile.twitter.com/" + tweetOptions.id
    dataType: "html"
    type: "GET"
  ).done (data) ->
    tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray()
    avatar = $(".avatar:lt(1) img", data.results[0])

    $('.tweet-avatar').attr('src', $(avatar[0]).attr('src'))

    tweets.forEach (tweet) ->
      tweetText = $(tweet).find(".tweet-text p").text()
      tweetTimestamp = $(tweet).find(".timestamp")
      tweetTime = tweetTimestamp.text()
      tweetUrl = "http://www.twitter.com" + tweetTimestamp.find("a").attr("href")

      tweetTemplate = "<span class='tweet-text'>" + tweetText +
      "<a href=" + tweetUrl + " class='tweet-date' target='_blank'>" + tweetTime + "</a></span>"

      $('.twitter-feed').append(tweetTemplate)

