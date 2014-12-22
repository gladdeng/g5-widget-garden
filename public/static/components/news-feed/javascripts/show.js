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

}).call(this);
