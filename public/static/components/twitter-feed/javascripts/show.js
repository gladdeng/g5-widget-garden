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
      var avatarUrl, replyHtml, time, timestamp, tweetHtml, url, user, userInfo, userName, userUrl;
      timestamp = $(tweet).find(".timestamp");
      user = timestamp.find("a").attr("href");
      userName = $(tweet).find('.fullname').html();
      time = timestamp.text();
      avatarUrl = $(avatar[0]).attr('src');
      userUrl = twitterUrl + '/' + userName;
      url = twitterUrl + user;
      tweetHtml = $(tweet).find(".tweet-text");
      replyHtml = tweetHtml.find(".twitter-atreply");
      if ($(tweet).has('.context').length > 0) {
        userInfo = $(tweet).find('.tweet-header');
        avatarUrl = userInfo.find(".avatar img").attr("src");
        userName = userInfo.find(".fullname").html();
      }
      replyHtml.each(function() {
        return $(this).attr("href", twitterUrl + $(this).attr("href"));
      });
      return composedTweets.push(tweetTemplate(avatarUrl, userName, userUrl, tweetHtml.html(), url, time));
    });
    if (tweetOptions.avatar !== true) {
      $('.tweet-avatar').hide();
    }
    return $('.tweet-list').append(composedTweets);
  };

  tweetTemplate = function(avatar, userName, userUrl, text, url, time) {
    return "<li><img class='tweet-avatar' src='" + avatar + "'/>  <a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a>  <a href=" + userUrl + " class='tweet-name' target='_blank'>" + userName + "</a>  <span class='tweet-text'> " + text + "</span></li>";
  };

  $(function() {
    var tweetOptions;
    tweetOptions = JSON.parse($('.twitter-feed .config:first').html());
    return initTweets(tweetOptions);
  });

}).call(this);
