(function() {
  var ssUnitMarkupBuilder;

  $(function() {
    var configs,
      _this = this;
    configs = JSON.parse($('#ss-featured-unit-categories-config').html());
    return $.ajax({
      url: "" + configs.unit_service_host,
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
        markupHash.push(buttonTemplate(category.name, configs));
      }
      allButton = " <div class='iui-size iui-view-all'>                    <a class='btn' href='" + configs.unit_page_url + "/#/category/all/units'>                      View All                    </a>                  </div> ";
      markupHash.push(allButton);
      $('.ss-featured-unit-categories .iui-container').html(markupHash.join(''));
    }

    buttonTemplate = function(name, configs) {
      return "<div class='iui-size'><a class='btn' href='" + configs.unit_page_url + "/#/category/" + name + "/units'>" + name + "</a></div>";
    };

    return ssUnitMarkupBuilder;

  })();

}).call(this);
