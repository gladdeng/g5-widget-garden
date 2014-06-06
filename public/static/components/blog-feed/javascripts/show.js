(function() {
  var BlogFetcher;

  $(function() {
    var blogConfig, blogVars;
    blogVars = JSON.parse($('.blog-feed .config:first').html());
    blogConfig = new window.BlogConfig(blogVars);
    return new window.BlogInterface($(".blog-feed ul"), blogConfig);
  });

  window.BlogConfig = (function() {
    function BlogConfig(config) {
      this.feedUrl = config.feedUrl, this.feedTitle = config.feedTitle, this.showAuthor = config.showAuthor, this.showEntrySummary = config.showEntrySummary, this.showDate = config.showDate, this.entriesToShow = config.entriesToShow;
    }

    return BlogConfig;

  })();

  BlogFetcher = (function() {
    function BlogFetcher(url) {
      this.url = url;
    }

    BlogFetcher.prototype.fetch = function() {
      var _this = this;
      return $.ajax({
        url: 'https://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=3&callback=?&q=' + encodeURIComponent(this.url),
        dataType: 'json',
        success: function(data) {
          _this.feed = data.responseData.feed;
          return $(_this).trigger("feedReady");
        }
      });
    };

    return BlogFetcher;

  })();

  window.BlogInterface = (function() {
    function BlogInterface(list, config) {
      var fetcher,
        _this = this;
      this.list = list;
      this.config = config;
      fetcher = new BlogFetcher(this.config.feedUrl);
      $(fetcher).bind("feedReady", function(event) {
        return _this.updateDom(event);
      });
      fetcher.fetch();
    }

    BlogInterface.prototype.updateDom = function(event) {
      var entry, feed, innerText, jli, _i, _len, _ref, _results;
      feed = event.currentTarget.feed;
      if (this.config.feedTitle != null) {
        this.list.before("<h2 class=\"title\">" + this.config.feedTitle + "</h2>");
      }
      _ref = feed.entries;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entry = _ref[_i];
        jli = $('<li class="h-entry hentry" itemscope itemtype="http://schema.org/BlogPosting">');
        innerText = "<a class='p-name entry-title u-url url' href=\"" + entry.link + "\" target=\"_blank\" itemprop='url'><span itemprop='headline'>" + entry.title + "</span></a><br />";
        if (this.config.showDate) {
          innerText += "<span class=\"dt-published published date\" itemprop='datePublished'>" + (this.formatDate(entry.publishedDate)) + "</span>";
        }
        if (this.config.showEntrySummary) {
          innerText += "<div class='p-summary summary' itemprop='description'>" + entry.contentSnippet + "</div>";
        }
        if (this.config.showAuthor) {
          innerText += "<div class='p-author author' itemprop='author'>Posted By: " + entry.author + "</div>";
        }
        jli.append(innerText);
        _results.push(this.list.append(jli));
      }
      return _results;
    };

    BlogInterface.prototype.formatDate = function(postDate) {
      var date, day, month, year;
      date = new Date(Date.parse(postDate));
      day = date.getDate();
      month = date.getMonth();
      year = date.getFullYear();
      return "" + day + "/" + month + "/" + year;
    };

    return BlogInterface;

  })();

}).call(this);
