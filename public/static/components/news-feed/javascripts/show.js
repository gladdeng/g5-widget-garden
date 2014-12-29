(function() {
  var NewsFeedBuilder, NewsFeedSource, ToggleListener;

  $(function() {
    var configs, feedSource, feedURL,
      _this = this;
    configs = JSON.parse($('#news-feed-config').html());
    feedURL = "" + configs.newsServiceDomain + "/locations/" + configs.locationURN + "/news_feed.json";
    feedSource = new NewsFeedSource(feedURL);
    $(feedSource).bind("feedReady", function(event) {
      new NewsFeedBuilder(configs, feedSource.feed);
      return new ToggleListener(configs);
    });
    return feedSource.getFeed();
  });

  NewsFeedBuilder = (function() {
    function NewsFeedBuilder(configs, feed) {
      this.configs = configs;
      this.feed = feed;
      this.populateFeed();
    }

    NewsFeedBuilder.prototype.populateFeed = function() {
      var index, markup, post, postCount, websitePosts, _i, _len;
      postCount = parseInt(this.configs.numberOfPosts);
      if (isNaN(postCount)) {
        postCount = 5;
      }
      websitePosts = this.feed.slice(0, postCount);
      markup = [];
      for (index = _i = 0, _len = websitePosts.length; _i < _len; index = ++_i) {
        post = websitePosts[index];
        markup.push("<div class='news-feed-post'>                      " + (this.toggleMarkup(post)) + "                      " + (this.detailsMarkup(post)) + "                      <div class='post-body'>" + post.text + "</div>                      <a class='post-toggle post-expand' href='#'>Read More</a>                      <a class='post-toggle post-collapse' href='#'>Hide This</a>                    </div>");
      }
      return $('.news-feed-widget').append(markup.join(''));
    };

    NewsFeedBuilder.prototype.toggleMarkup = function(post) {
      var toggle;
      toggle = "<a class='post-toggle' href='#'>";
      if (post.image !== "") {
        toggle += "  <img src='" + post.image + "' />";
      }
      if (post.title !== "") {
        toggle += "  <h3 class='post-title'>" + post.title + "</h3>";
      }
      return toggle += "</a>";
    };

    NewsFeedBuilder.prototype.detailsMarkup = function(post) {
      var details;
      if (post.title !== "") {
        details = "<span class='post-date'>" + post.pretty_date + "</span>";
      }
      if (post.author !== "") {
        details += "<span>|</span><span class='post-author'>by " + post.author + "</span>";
      }
      if (post.description !== "") {
        return details += "<div class='post-description'>" + post.description + "</div>";
      }
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

  NewsFeedSource = (function() {
    function NewsFeedSource(url) {
      this.url = url;
    }

    NewsFeedSource.prototype.getFeed = function() {
      if (this.feedFromStorage()) {
        return $(this).trigger("feedReady");
      } else {
        return this.fetch();
      }
    };

    NewsFeedSource.prototype.fetch = function() {
      var _this = this;
      return $.ajax({
        url: this.url,
        dataType: 'json',
        success: function(data, status, xhr) {
          _this.feed = data;
          _this.storeFeed();
          return $(_this).trigger("feedReady");
        },
        error: function(xhr, status, error) {}
      });
    };

    NewsFeedSource.prototype.feedFromStorage = function() {
      try {
        return this.feed = JSON.parse(sessionStorage.getItem(this.url));
      } catch (_error) {
        return null;
      }
    };

    NewsFeedSource.prototype.storeFeed = function() {
      try {
        return sessionStorage.setItem(this.url, JSON.stringify(this.feed));
      } catch (_error) {
        return null;
      }
    };

    return NewsFeedSource;

  })();

}).call(this);
