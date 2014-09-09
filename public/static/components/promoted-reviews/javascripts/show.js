(function() {
  var BusinessSchemaUpdater, ReviewFeedSource, ReviewTemplater;

  $(function() {
    var config, feedSource,
      _this = this;
    config = JSON.parse($('#promoted-reviews-config').html());
    feedSource = new ReviewFeedSource(config.review_api_url);
    if (config.insert_review_schema) {
      $(feedSource).bind("feedReady", function(event) {
        return new BusinessSchemaUpdater(config.insert_review_schema, config.review_page_url).update(feedSource.feed);
      });
    }
    if (config.full_review_content) {
      $(feedSource).bind("feedReady", function(event) {
        return new ReviewTemplater(config.branded_name).update(feedSource.feed);
      });
    }
    return feedSource.getFeed();
  });

  ReviewFeedSource = (function() {
    function ReviewFeedSource(url) {
      this.url = url;
    }

    ReviewFeedSource.prototype.getFeed = function() {
      if (this.feedFromStorage()) {
        return $(this).trigger("feedReady");
      } else {
        return this.fetch();
      }
    };

    ReviewFeedSource.prototype.fetch = function() {
      var _this = this;
      alert("Hitting the deervices");
      return $.ajax({
        url: this.url,
        dataType: 'json',
        success: function(data, status, xhr) {
          _this.feed = data;
          _this.storeFeed();
          return $(_this).trigger("feedReady");
        },
        error: function(xhr, status, error) {
          if (!_this.url) {
            return alert("Review API URL not configured");
          }
        }
      });
    };

    ReviewFeedSource.prototype.feedFromStorage = function() {
      try {
        return this.feed = JSON.parse(sessionStorage.getItem(this.url));
      } catch (_error) {
        return null;
      }
    };

    ReviewFeedSource.prototype.storeFeed = function() {
      try {
        return sessionStorage.setItem(this.url, JSON.stringify(this.feed));
      } catch (_error) {
        return null;
      }
    };

    return ReviewFeedSource;

  })();

  BusinessSchemaUpdater = (function() {
    function BusinessSchemaUpdater(insert_review_schema, review_page_url) {
      this.insert_review_schema = insert_review_schema;
      this.review_page_url = review_page_url;
    }

    BusinessSchemaUpdater.prototype.update = function(feed) {
      return $(this.insert_review_schema).append(this.schemaTemplate(feed.location));
    };

    BusinessSchemaUpdater.prototype.schemaTemplate = function(location) {
      return "<div itemprop=\"aggregateRating\" itemscope itemtype=\"http://schema.org/AggregateRating\" class=\"rating\">\n  <span itemprop=\"ratingValue\" class=\"average-rating\">" + location.average_rating + " stars</span>\n  <a href=\"" + this.review_page_url + "\" class=\"total-reviews\">\n    <span itemprop=\"reviewCount\">(" + location.review_count + " reviews)</span>\n  </a>\n  <span class=\"gold-stars\" style=\"width:" + (Math.round(location.average_rating * 16)) + "px;\"></span>\n</div>";
    };

    return BusinessSchemaUpdater;

  })();

  ReviewTemplater = (function() {
    function ReviewTemplater(branded_name) {
      this.branded_name = branded_name;
    }

    ReviewTemplater.prototype.update = function(feed) {
      var review, _i, _len, _ref, _results;
      _ref = feed.reviews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        review = _ref[_i];
        _results.push($('#promoted-reviews').append(this.reviewTemplate(feed.location, review)));
      }
      return _results;
    };

    ReviewTemplater.prototype.reviewTemplate = function(location, review) {
      return "<div itemscope itemtype=\"http://schema.org/Review\" itemprop=\"review\" class=\"review\">\n  <div itemprop=\"reviewBody\" class=\"review-body\">" + review.excerpt + "</div>\n  <div itemprop=\"itemreviewed\">" + this.branded_name + "</div>\n  <div itemprop=\"author\" itemscope itemtype=\"http://schema.org/Person\" class=\"author\">\n    Written by: <span itemprop=\"name\">" + review.author + "</span> \n    <span class=\"" + (this.classifyReputationSiteName(review.reputation_site_name)) + " via\">\n      via " + review.reputation_site_name + "\n    </span>\n  </div>\n  <div class=\"date\">\n    <meta itemprop=\"datePublished\" content=\"" + review.date + "\">Date published: " + review.date + "\n  </div>\n  <div itemprop=\"reviewRating\" itemscope itemtype=\"http://schema.org/Rating\" class=\"rating\">\n    <meta itemprop=\"worstRating\" content=\"1\"><span itemprop=\"ratingValue\">" + review.rating + "</span> / <span itemprop=\"bestRating\">" + location.out_of + "</span> stars\n    <span class=\"gold-stars\" style=\"width:" + (Math.round(review.rating * 16)) + "px;\"></span>\n  </div>\n</div>";
    };

    ReviewTemplater.prototype.classifyReputationSiteName = function(name) {
      return this.lowercaseFirstChar(name).replace(/[^0-9a-z]/i, '');
    };

    ReviewTemplater.prototype.lowercaseFirstChar = function(string) {
      return string.charAt(0).toLowerCase() + string.slice(1);
    };

    return ReviewTemplater;

  })();

}).call(this);
