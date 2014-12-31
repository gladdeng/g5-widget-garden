(function() {
  var ssUnitMarkupBuilder;

  $(function() {
    var configs,
      _this = this;
    configs = ssFeaturedUnitCategories;
    return $.ajax({
      url: "" + configs.unit_service_host + "/api/v1/storage_facilities/" + configs.location_urn + "/storage_categories",
      dataType: 'json',
      success: function(data) {
        var categories;
        categories = data.storage_categories;
        if (typeof categories !== "undefined" && categories.length > 0) {
          return new ssUnitMarkupBuilder(categories, configs);
        }
      }
    });
  });

  ssUnitMarkupBuilder = (function() {
    var buttonTemplate;

    function ssUnitMarkupBuilder(categories, configs) {
      var allButton, category, index, markupHash, _i, _len;
      categories.sort(function(a, b) {
        return a.name - b.name;
      });
      markupHash = [];
      for (index = _i = 0, _len = categories.length; _i < _len; index = ++_i) {
        category = categories[index];
        markupHash.push(buttonTemplate(category.id, category.name, configs));
      }
      allButton = " <div class='iui-size iui-view-all'>                    <a class='btn' href='" + configs.unit_page_url + "/#/size'>                      View All                    </a>                  </div> ";
      markupHash.push(allButton);
      $('.ss-featured-unit-categories .iui-container').html(markupHash.join(''));
    }

    buttonTemplate = function(id, name, configs) {
      return "<div class='iui-size'><a class='btn' href='" + configs.unit_page_url + "/#/options?categoryID=" + id + "'>" + name + "</a></div>";
    };

    return ssUnitMarkupBuilder;

  })();

}).call(this);
