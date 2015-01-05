(function() {
  var MiniNewsFeedSource, MiniNewsFeedWidthChecker, NewsLinkBuilder;

  $(function() {
    var configs, feedSource, feedURL,
      _this = this;
    configs = JSON.parse($('#mini-news-feed-config').html());
    feedURL = "" + configs.newsServiceDomain + "/locations/" + configs.locationURN + "/news_feed.json";
    feedSource = new MiniNewsFeedSource(feedURL);
    $(feedSource).bind("feedReady", function(event) {
      return new NewsLinkBuilder(configs, feedSource.feed);
    });
    feedSource.getFeed();
    return new MiniNewsFeedWidthChecker();
  });

  NewsLinkBuilder = (function() {
    function NewsLinkBuilder(configs, feed) {
      this.configs = configs;
      this.feed = feed;
      this.populateFeed();
    }

    NewsLinkBuilder.prototype.populateFeed = function() {
      var index, markup, post, postCount, websitePosts, _i, _len;
      postCount = parseInt(this.configs.numberOfPosts);
      if (isNaN(postCount)) {
        postCount = 5;
      }
      websitePosts = this.feed.slice(0, postCount);
      markup = [];
      for (index = _i = 0, _len = websitePosts.length; _i < _len; index = ++_i) {
        post = websitePosts[index];
        markup.push("<a class='news-item-link' href='" + this.configs.newsPagePath + "?article-index=" + index + "' data-post-index='" + index + "'>                      <img src='" + post.image + "' />                      <h3 class='post-title'>" + post.title + "</h3>                      <span class='post-date'>" + post.pretty_date + "</span>                      <span>|</span>                      <span class='post-author'>by " + post.author + "</span>                      <div class='post-description'>" + post.description + "</div>                    </a>");
      }
      return $('.mini-news-feed-widget').append(markup.join(''));
    };

    return NewsLinkBuilder;

  })();

  MiniNewsFeedSource = (function() {
    function MiniNewsFeedSource(url) {
      this.url = url;
    }

    MiniNewsFeedSource.prototype.getFeed = function() {
      if (this.feedFromStorage()) {
        return $(this).trigger("feedReady");
      } else {
        return this.fetch();
      }
    };

    MiniNewsFeedSource.prototype.fetch = function() {
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

    MiniNewsFeedSource.prototype.feedFromStorage = function() {
      try {
        return this.feed = JSON.parse(sessionStorage.getItem(this.url));
      } catch (_error) {
        return null;
      }
    };

    MiniNewsFeedSource.prototype.storeFeed = function() {
      try {
        return sessionStorage.setItem(this.url, JSON.stringify(this.feed));
      } catch (_error) {
        return null;
      }
    };

    return MiniNewsFeedSource;

  })();

  MiniNewsFeedWidthChecker = (function() {
    function MiniNewsFeedWidthChecker() {
      var _this = this;
      this.applyWidthClasses();
      $(window).resize(function() {
        return _this.applyWidthClasses();
      });
    }

    MiniNewsFeedWidthChecker.prototype.applyWidthClasses = function() {
      var container, width;
      container = $("#mini-news-feed-widget");
      width = container.width();
      if (width <= 460) {
        return container.removeClass("wide").addClass("narrow");
      } else {
        return container.removeClass("narrow").addClass("wide");
      }
    };

    return MiniNewsFeedWidthChecker;

  })();

}).call(this);
