(function() {
  var LinkMaker;

  $(function() {
    var ssFeaturedUnitCat,
      _this = this;
    ssFeaturedUnitCat = JSON.parse($('#ss-featured-categories-config').html());
    return $.ajax({
      url: "" + ssFeaturedUnitCat.configuration,
      dataType: 'json',
      success: function(data) {
        return new LinkMaker(data).update();
      }
    });
  });

  LinkMaker = (function() {
    function LinkMaker(data) {
      this.data = data;
    }

    LinkMaker.prototype.update = function() {
      var category, _i, _len, _ref, _results;
      _ref = this.data.storage_categories;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        category = _ref[_i];
        _results.push($('.ss-featured-categories').append(this.buttonTemplate(category)));
      }
      return _results;
    };

    LinkMaker.prototype.buttonTemplate = function(category) {
      return "<div>\n  <p>" + category.name + "</p>\n  <p>" + category.from_price + "</p>\n  <p>" + category.has_specials + "</p>\n</div>";
    };

    return LinkMaker;

  })();

}).call(this);
