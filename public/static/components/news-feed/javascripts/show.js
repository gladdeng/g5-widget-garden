(function() {
  var NewsFeedBuilder, ToggleListener;

  $(function() {
    var configs,
      _this = this;
    configs = JSON.parse($('#news-feed-config').html());
    return $.ajax({
      url: "" + configs.newsServiceDomain + "/locations/" + configs.locationURN + "/news_feed.json",
      dataType: 'json',
      success: function(data) {
        new NewsFeedBuilder(configs, data);
        return new ToggleListener(configs);
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
      _ref = this.feed;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        post = _ref[index];
        markup.push("<div class='news-feed-post'>                      <a class='post-toggle' href='#'>                        <img src='" + post.image + "' />                        <div class='post-title'>" + post.title + "</div>                      </a>                      <div class='post-date'>" + post.date + "</div>                      <div class='post-author'>" + post.author + "</div>                      <div class='post-description'>" + post.description + "</div>                      <div class='post-body'>" + post.text + "</div>                      <a class='post-toggle post-expand' href='#'>Read More</a>                      <a class='post-toggle post-collapse' href='#'>Less</a>                    </div>");
      }
      return $('.news-feed-widget').append(markup.join(''));
    };

    return NewsFeedBuilder;

  })();

  ToggleListener = (function() {
    function ToggleListener(configs) {
      this.configs = configs;
      this.basicListener();
    }

    ToggleListener.prototype.basicListener = function() {
      return $('.post-toggle').click(function() {
        $(this).parent().toggleClass("active-post");
        return false;
      });
    };

    return ToggleListener;

  })();

}).call(this);
