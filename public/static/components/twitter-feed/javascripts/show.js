(function() {
  var composeAtReply, composeTweet, tweetTemplate;

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
    var composedTweets;
    composedTweets = [];
    tweets.forEach(function(tweet) {
      var avatarUrl, text, time, timestamp, url, user;
      timestamp = $(tweet).find(".timestamp");
      user = timestamp.find("a").attr("href");
      time = timestamp.text();
      avatarUrl = $(avatar[0]).attr('src');
      url = "http://www.twitter.com" + user;
      text = composeAtReply(tweet) + $(tweet).find(".tweet-text p").html();
      return composedTweets.push(tweetTemplate(avatarUrl, text, url, time));
    });
    if (tweetOptions.avatar !== true) {
      $('.tweet-avatar').hide();
    }
    return $('.tweet-list').append(composedTweets);
  };

  tweetTemplate = function(avatar, text, url, time) {
    return "<li><img class='tweet-avatar' src='" + avatar + "'/>  <span class='tweet-text'> " + text + "<a href=" + url + " class='tweet-date' target='_blank'>" + time + " ago</a></span></li>";
  };

  composeAtReply = function(tweet) {
    var atReplyHTML, replyTemplates;
    atReplyHTML = $(tweet).find(".tweet-text .twitter-atreply");
    replyTemplates = [];
    atReplyHTML.each(function(reply) {
      var fullReply, replyText, replyUrl, template;
      fullReply = atReplyHTML.get(reply);
      replyUrl = 'http://www.twitter.com' + $(fullReply).attr("href");
      replyText = $(fullReply).text();
      template = "<a href='" + replyUrl + "' target='_blank'>" + replyText + "</a> ";
      return replyTemplates.push(template);
    });
    return replyTemplates.join(" ");
  };

  $(function() {
    var tweetOptions;
    tweetOptions = JSON.parse($('.twitter-feed .config:first').html());
    return initTweets(tweetOptions);
  });

}).call(this);
