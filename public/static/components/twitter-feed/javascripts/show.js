(function() {
  var composeTweet, tweetTemplate;

  window.initTweets = function(tweetOptions) {
    return $.ajax({
      url: "https://mobile.twitter.com/" + tweetOptions.id,
      dataType: "html",
      type: "GET"
    }).done(function(data) {
      var avatar, tweets;
      tweets = $(".timeline .tweet:lt(" + tweetOptions.count + ")", data.results[0]).toArray();
      avatar = $(".avatar:lt(1) img", data.results[0]);
      return composeTweet(data, tweets, avatar);
    });
  };

  composeTweet = function(tweetOptions, tweets, avatar) {
    var composedTweets, twitterUrl;
    twitterUrl = "http://www.twitter.com";
    composedTweets = [];
    tweets.forEach(function(tweet) {
      var avatarUrl, replyHtml, time, timestamp, tweetHtml, url, user;
      timestamp = $(tweet).find(".timestamp");
      user = timestamp.find("a").attr("href");
      time = timestamp.text();
      avatarUrl = $(avatar[0]).attr('src');
      url = twitterUrl + user;
      tweetHtml = $(tweet).find(".tweet-text");
      replyHtml = tweetHtml.find(".twitter-atreply");
      replyHtml.each(function() {
        return $(this).attr("href", twitterUrl + $(this).attr("href"));
      });
      return composedTweets.push(tweetTemplate(avatarUrl, tweetHtml.html(), url, time));
    });
    if (tweetOptions.avatar !== true) {
      $('.tweet-avatar').hide();
    }
    return $('.tweet-list').append(composedTweets);
  };

  tweetTemplate = function(avatar, text, url, time) {
    return "<li><img class='tweet-avatar' src='" + avatar + "'/>  <span class='tweet-text'> " + text + "<a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a></span></li>";
  };

  $(function() {
    var tweetOptions;
    tweetOptions = JSON.parse($('.twitter-feed .config:first').html());
    return initTweets(tweetOptions);
  });

}).call(this);
