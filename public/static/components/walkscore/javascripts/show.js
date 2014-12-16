(function() {
  var walkscoreBadgeBuilder, walkscoreInitializer;

  $(function() {
    var walkFeedVars, walkscoreFeed;
    walkFeedVars = JSON.parse($("#walkscore-config:first").html());
    if (walkFeedVars.walkscore_client.length > 1) {
      return walkscoreFeed = new walkscoreInitializer(walkFeedVars);
    }
  });

  walkscoreInitializer = (function() {
    var getpage;

    function walkscoreInitializer(walkFeedVars) {
      return getpage(walkFeedVars);
    }

    getpage = function(walkFeedVars) {
      var _this = this;
      return $.ajax({
        url: "http://localhost:3008/walkscore-feed/" + walkFeedVars.walkscore_client + "/" + walkFeedVars.walkscore_location,
        dataType: 'json',
        success: function(data) {
          return walkscoreBadgeBuilder(data);
        }
      });
    };

    return walkscoreInitializer;

  })();

  walkscoreBadgeBuilder = function(dataFeed) {
    var walkscoreBlock;
    walkscoreBlock = "<a href=\"" + dataFeed.ws_link + "\" target=\"_blank\">\n <img src=\"" + dataFeed.logo_url + "\" alt=\"Walkscore Logo\"/>\n   <span>" + dataFeed.walkscore + "</span>\n</a>";
    return $('.walkscore-listing').append(walkscoreBlock);
  };

}).call(this);
