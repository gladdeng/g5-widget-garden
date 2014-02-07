(function() {
  $(function() {
    var tweetOptions;
    tweetOptions = JSON.parse($('.twitter-feed .config:first').html());
    return $.ajax({
      url: "https://mobile.twitter.com/" + tweetOptions.id,
      dataType: "html",
      type: "GET"
    }).done(function(data) {
      var avatar, tweets;
      tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray();
      avatar = $(".avatar:lt(1) img", data.results[0]);
      return tweets.forEach(function(tweet) {
        var atReply, atReplyUrl, atReplyUser, tweetAvatar, tweetTemplate, tweetText, tweetTime, tweetTimestamp, tweetUrl;
        atReply = $(tweet).find(".tweet-text .twitter-atreply");
        atReplyUser = function() {
          var replyText;
          replyText = [];
          atReply.each(function(reply) {
            var username;
            username = atReply.get(reply);
            return replyText.push($(username).text());
          });
          return replyText.join(" ");
        };
        atReplyUrl = 'http://www.twitter.com' + atReply.attr("href");
        tweetText = $(tweet).find(".tweet-text p").text().trim();
        tweetTimestamp = $(tweet).find(".timestamp");
        tweetTime = tweetTimestamp.text();
        tweetAvatar = $(avatar[0]).attr('src');
        tweetUrl = "http://www.twitter.com" + tweetTimestamp.find("a").attr("href");
        tweetTemplate = "<li><img class='tweet-avatar' src='" + tweetAvatar + "'/>        <span class='tweet-text'> <a href='" + atReplyUrl + "' target='_blank'>" + atReplyUser() + "</a> " + tweetText + "<a href=" + tweetUrl + " class='tweet-date' target='_blank'>" + tweetTime + " ago</a></span></li>";
        if (tweetOptions.avatar !== true) {
          $('.tweet-avatar').hide();
        }
        return $('.tweet-list').append(tweetTemplate);
      });
    });
  });

}).call(this);
