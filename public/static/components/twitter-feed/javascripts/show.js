(function() {
  $(function() {
    var tweetOptions;
    tweetOptions = JSON.parse($('#twitter-feed-config:first').html());
    return $.ajax({
      url: "https://mobile.twitter.com/" + tweetOptions.id,
      dataType: "html",
      type: "GET"
    }).done(function(data) {
      var avatar, tweets;
      tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray();
      avatar = $(".avatar:lt(1) img", data.results[0]);
      return tweets.forEach(function(tweet) {
        var tweetAvatar, tweetTemplate, tweetText, tweetTime, tweetTimestamp, tweetUrl;
        tweetText = $(tweet).find(".tweet-text p").text();
        tweetTimestamp = $(tweet).find(".timestamp");
        tweetTime = tweetTimestamp.text();
        tweetAvatar = $(avatar[0]).attr('src');
        tweetUrl = "http://www.twitter.com" + tweetTimestamp.find("a").attr("href");
        tweetTemplate = "<img class='tweet-avatar' src='" + tweetAvatar + "'/> <span class='tweet-text'>" + tweetText + "<a href=" + tweetUrl + " class='tweet-date' target='_blank'>" + tweetTime + " ago</a></span>";
        if (tweetOptions.avatar !== true) {
          $('.tweet-avatar').hide();
        }
        return $('.tweet-list').append(tweetTemplate);
      });
    });
  });

}).call(this);
