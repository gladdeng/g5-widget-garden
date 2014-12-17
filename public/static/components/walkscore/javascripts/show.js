(function() {
  var walkscoreInitializer;

  $(function() {
    var walkFeedVars, walkscoreFeed;
    walkFeedVars = JSON.parse($("#walkscore-config").html());
    if (walkFeedVars.walkscore_client.length > 1) {
      return walkscoreFeed = new walkscoreInitializer(walkFeedVars);
    }
  });

  walkscoreInitializer = (function() {
    function walkscoreInitializer(walkFeedVars) {
      this.getpage(walkFeedVars);
    }

    walkscoreInitializer.prototype.getpage = function(walkFeedVars) {
      var _this = this;
      return $.ajax({
        url: "http://localhost:3008/walkscore-feed/" + walkFeedVars.walkscore_client + "/" + walkFeedVars.walkscore_location + "sfdsfs",
        dataType: 'json',
        success: function(data) {
          debugger;
          return _this.walkscoreBadgeBuilder(data);
        }
      });
    };

    walkscoreInitializer.prototype.walkscoreBadgeBuilder = function(dataFeed) {
      var walkscoreBlock;
      if (dataFeed !== []) {
        walkscoreBlock = "<a href=\"" + dataFeed.ws_link + "\" target=\"_blank\">\n <img src=\"" + dataFeed.logo_url + "\" alt=\"Walkscore Logo\"/>\n   <span>" + dataFeed.walkscore + "</span>\n</a>";
        return $('.walkscore-listing').append(walkscoreBlock);
      }
    };

    return walkscoreInitializer;

  })();

}).call(this);
