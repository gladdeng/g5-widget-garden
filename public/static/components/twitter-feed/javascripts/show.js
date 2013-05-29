(function() {
  $(function() {
    var tweetOptions;

    tweetOptions = JSON.parse($('#twitter-feed-config:first').html());
    tweetOptions.template = tweetOptions.template.replace(/\\/g, "");
    return getTwitters('tweets', tweetOptions);
  });

}).call(this);
