(function() {
  var BlogFetcher, facebookFeedBuilder, facebookInitializer, tabListener, tweetBuilder, tweetInitializer;

  $(function() {
    var blogConfig, facebookFeed, feedVars;
    feedVars = JSON.parse($('#social-feed-config').html());
    if (feedVars.twitter_username.length > 1) {
      new tweetInitializer(feedVars);
    }
    if (feedVars.feed_url.length > 10) {
      blogConfig = new window.BlogConfig(feedVars);
      new window.BlogInterface($("#blog-feed .feed"), blogConfig);
    }
    return facebookFeed = new facebookInitializer(feedVars);
  });

  window.BlogConfig = (function() {
    function BlogConfig(config) {
      this.feed_url = config.feed_url, this.feedTitle = config.feedTitle, this.showAuthor = config.showAuthor, this.show_entry_summary = config.show_entry_summary, this.entries_to_show = config.entries_to_show;
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
      fetcher = new BlogFetcher(this.config.feed_url);
      $(fetcher).bind("feedReady", function(event) {
        return _this.updateDom(event);
      });
      fetcher.fetch();
    }

    BlogInterface.prototype.updateDom = function(event) {
      var entry, feed, feedBlock, feedEntry, feedList, feedTab, innerText, _i, _len, _ref;
      feed = event.currentTarget.feed;
      feedList = "";
      _ref = feed.entries;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entry = _ref[_i];
        feedEntry = '<li class="h-entry hentry" itemscope itemtype="http://schema.org/BlogPosting">';
        innerText = " <a class='p-name entry-title u-url url' href='" + entry.link + "' target='_blank' itemprop='url'>                      <span itemprop='headline'>" + entry.title + "</span>                    </a>                    <br /> ";
        if (this.config.show_entry_summary) {
          innerText += "<p class='p-summary summary' itemprop='description'>" + entry.contentSnippet + "</p>";
        }
        if (this.config.showAuthor) {
          innerText += "<p class='p-author author' itemprop='author'>Posted By: " + entry.author + "</p>";
        }
        feedEntry += "" + innerText + "</li>";
        feedList += feedEntry;
      }
      feedTab = '<a class="feed-switch" id="feed-switch-blog" href="#blog-feed" title="Show Blog Feed">Show Blog Feed</a>';
      $('.feed-switcher').append(feedTab);
      feedBlock = " <div id='blog-feed' class='blog-feed feed-section' style='display: none;'>                    <ul class='h-feed feed'>" + feedList + "</ul>                  </div>";
      $('.social-feed').append(feedBlock);
      return new tabListener('#feed-switch-blog', '#blog-feed');
    };

    return BlogInterface;

  })();

  tweetInitializer = (function() {
    function tweetInitializer(feedVars) {
      $.ajax({
        url: "https://mobile.twitter.com/" + feedVars.twitter_username,
        dataType: "html",
        type: "GET"
      }).done(function(data) {
        var avatar, tweets;
        tweets = $(".timeline .tweet:lt(" + feedVars.tweet_count + ")", data.results[0]).toArray();
        avatar = $(".avatar:lt(1) img", data.results[0]);
        return new tweetBuilder(data, tweets, avatar);
      });
    }

    return tweetInitializer;

  })();

  tweetBuilder = (function() {
    var tweetTemplate;

    function tweetBuilder(feedVars, tweets, avatar) {
      var composedTweets, twitterBlock, twitterTab, twitterUrl;
      twitterUrl = "http://www.twitter.com";
      composedTweets = [];
      tweets.forEach(function(tweet) {
        var avatarUrl, replyHtml, timestamp, tweetHtml, url, user, userInfo, userName, userUrl;
        timestamp = $(tweet).find(".timestamp");
        user = timestamp.find("a").attr("href");
        avatarUrl = $(avatar[0]).attr('src');
        userName = $(tweet).find('.fullname').html();
        userUrl = twitterUrl + '/' + feedVars.twitter_username;
        url = twitterUrl + user;
        tweetHtml = $(tweet).find(".tweet-text");
        replyHtml = tweetHtml.find(".twitter-atreply");
        if ($(tweet).has('.context').length > 0) {
          userInfo = $(tweet).find('.tweet-header');
          avatarUrl = userInfo.find(".avatar img").attr("src");
          userName = userInfo.find(".fullname").html();
        }
        if (feedVars.display_avatar === false) {
          avatarUrl = 'https://widgets.g5dxm.com/social-feed/icon-speech.png';
        }
        replyHtml.each(function() {
          return $(this).attr("href", twitterUrl + $(this).attr("href"));
        });
        return composedTweets.push(tweetTemplate(avatarUrl, userName, userUrl, tweetHtml.html(), url));
      });
      twitterTab = '<a class="feed-switch" id="feed-switch-twitter" href="#twitter-feed" title="Show Tweets">Show Twitter Feed</a>';
      $('.feed-switcher').append(twitterTab);
      twitterBlock = "<div id='twitter-feed' class='twitter-feed feed-section' style='display:none;'>                      <ul class='tweet-list'>                        " + (composedTweets.join('')) + "                      </ul>                      <a class='btn' href='http://www.twitter.com/" + feedVars.twitter_username + "' href='#' target='_blank'>Read All</a>                    </div>";
      $('.social-feed').append(twitterBlock);
      new tabListener('#feed-switch-twitter', '#twitter-feed');
    }

    tweetTemplate = function(avatar, userName, userUrl, text, url) {
      return " <li>        <span class='tweet-avatar'><img src='" + avatar + "'/></span>        <a href='" + url + "' class='tweet-name' target='_blank'> " + userName + " says:</a>        <span class='tweet-text'> " + text + "</span>      </li>";
    };

    return tweetBuilder;

  })();

  facebookInitializer = (function() {
    var getpage;

    function facebookInitializer(feedVars) {
      return getpage(feedVars);
    }

    getpage = function(feedVars) {
      var _this = this;
      return $.ajax({
        url: "http://localhost:4000/facebook_feed/" + feedVars.facebook_page_id,
        dataType: 'json',
        success: function(data) {
          return new facebookFeedBuilder(feedVars, data);
        }
      });
    };

    return facebookInitializer;

  })();

  facebookFeedBuilder = (function() {
    var postTemplate;

    function facebookFeedBuilder(feedVars, dataFeed) {
      var facebookBlock, facebookFeedList, facebookTab, index, post, _i, _len, _ref;
      facebookTab = '<a class="feed-switch" id="feed-switch-facebook" href="#facebook-feed" title="Show Facebook Feed">Show Facebook Feed</a>';
      $('.feed-switcher').append(facebookTab);
      facebookFeedList = [];
      _ref = dataFeed.data;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        post = _ref[index];
        debugger;
        if ((index + 1) > feedVars.facebook_post_limit) {
          break;
        }
        facebookFeedList.push(postTemplate(post.created_time, post.message));
      }
      facebookBlock = "<div id='facebook-feed' class='facebook-feed feed-section' style='display:none;'>                      <ul class='tweet-list'>                        " + (facebookFeedList.join('')) + "                      </ul>                    </div>";
      $('.social-feed').append(facebookBlock);
      new tabListener('#feed-switch-facebook', '#facebook-feed');
    }

    postTemplate = function(created_time, message) {
      return " <li>        " + created_time + "<br/>" + message + "      </li>";
    };

    return facebookFeedBuilder;

  })();

  tabListener = (function() {
    function tabListener(tab, block) {
      $('.social-feed').on('click', tab, function(e) {
        $('.social-feed .feed-switch').removeClass('active');
        $(this).addClass('active');
        $('.feed-section').css('display', 'none');
        $(block).css('display', 'block');
        return false;
      });
      if ($('.feed-switcher a').length === 1) {
        $(tab).addClass('active');
        $(block).css('display', 'block');
      }
    }

    return tabListener;

  })();

}).call(this);
