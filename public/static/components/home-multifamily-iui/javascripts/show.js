(function() {
  var iuiMarkupBuilder;

  $(function() {
    var configs,
      _this = this;
    configs = JSON.parse($('#home-multifamily-iui-config').html());
    return $.ajax({
      url: "http://www.g5api.com/api/v0/multi_families?store_id=" + configs.core_store_id,
      dataType: 'json',
      success: function(data) {
        var categories;
        categories = data.unit_categories;
        if (typeof categories !== "undefined" && categories.length > 0) {
          return new iuiMarkupBuilder(categories, configs);
        }
      }
    });
  });

  iuiMarkupBuilder = (function() {
    var buttonTemplate;

    function iuiMarkupBuilder(categories, configs) {
      var category, index, markupHash, _i, _len;
      markupHash = [];
      for (index = _i = 0, _len = categories.length; _i < _len; index = ++_i) {
        category = categories[index];
        markupHash.push(buttonTemplate(category.beds, configs));
      }
      markupHash.push("<div class='iui-size iui-view-all'><a class='btn' href=''>View All</a></div>");
      $('.home-multifamily-iui .iui-container').html(markupHash.join(''));
    }

    buttonTemplate = function(beds, configs) {
      return "<div class='iui-size'><a class='btn' href='" + configs.floorplan_page_url + "#/bedrooms/" + beds + "/floorplans'>" + beds + " Bedroom</a></div>";
    };

    return iuiMarkupBuilder;

  })();

}).call(this);
