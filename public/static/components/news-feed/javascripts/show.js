(function() {
  var FeedSlurper;

  $(function() {
    var configs, newsFeed;
    configs = JSON.parse($('#news-feed-config').html());
    return newsFeed = new FeedSlurper(configs);
  });

  FeedSlurper = (function() {
    function FeedSlurper(configs) {
      var _this = this;
      this.configs = configs;
      $.ajax({
        url: "" + this.configs.newsServiceDomain + "/locations/" + this.configs.locationURN + "/news_feed.json",
        dataType: 'json',
        success: function(data) {
          alert("(.Y.)");
          debugger;
        }
      });
    }

    return FeedSlurper;

  })();

}).call(this);
