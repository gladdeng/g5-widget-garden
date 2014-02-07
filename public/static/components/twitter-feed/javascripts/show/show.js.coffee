$ ->
  tweetOptions = JSON.parse($('.twitter-feed .config:first').html())

  $.ajax(
    url: "https://mobile.twitter.com/" + tweetOptions.id
    dataType: "html"
    type: "GET"
  ).done (data) ->
    tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray()
    avatar = $(".avatar:lt(1) img", data.results[0])

    tweets.forEach (tweet) ->
      atReplyHTML = $(tweet).find(".tweet-text .twitter-atreply")

      atReply = ->
        replyTemplates = []
        atReplyHTML.each (reply) ->
          fullReply = atReplyHTML.get(reply)
          replyUrl = 'http://www.twitter.com' + $(fullReply).attr("href")
          replyText = $(fullReply).text()
          template = "<a href='" + replyUrl + "' target='_blank'>" + replyText + "</a> "
          replyTemplates.push(template)

        replyTemplates.join(" ")

      tweetText = $(tweet).find(".tweet-text p").text()
      tweetTimestamp = $(tweet).find(".timestamp")
      tweetTime = tweetTimestamp.text()
      tweetAvatar = $(avatar[0]).attr('src')
      tweetUrl = "http://www.twitter.com" + tweetTimestamp.find("a").attr("href")

      tweetTemplate = "<li><img class='tweet-avatar' src='" + tweetAvatar + "'/>
        <span class='tweet-text'> " + atReply() + tweetText +
        "<a href=" + tweetUrl + " class='tweet-date' target='_blank'>" + tweetTime + " ago</a></span></li>"

      $('.tweet-avatar').hide() unless tweetOptions.avatar is true
      $('.tweet-list').append(tweetTemplate)

