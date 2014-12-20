(function() {
  var NewsFeedBuilder;

  $(function() {
    var configs,
      _this = this;
    configs = JSON.parse($('#news-feed-config').html());
    return $.ajax({
      url: "" + configs.newsServiceDomain + "/locations/" + configs.locationURN + "/news_feed.json",
      dataType: 'json',
      success: function(data) {
        return new NewsFeedBuilder(configs, data);
      }
    });
  });

  NewsFeedBuilder = (function() {
    function NewsFeedBuilder(configs, feed) {
      this.configs = configs;
      this.feed = feed;
      this.populateFeed();
    }

    NewsFeedBuilder.prototype.populateFeed = function() {
      var index, markup, post, _i, _len, _ref;
      markup = [];
      markup.push("<h2>Fuckin-A</h2>");
      _ref = this.feed;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        post = _ref[index];
        markup.push("<div class='news-feed-post'>                      <img src='" + post.image + "' />                      <div>" + post.title + "</div>                      <div>" + post.author + "</div>                      <div>" + post.date + "</div>                      <div>" + post.description + "</div>                      <div>" + post.text + "</div>                    </div>");
      }
      return $('.news-feed-widget').append(markup.join(''));
    };

    return NewsFeedBuilder;

  })();

}).call(this);
