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
    ssUnitMarkupBuilder.prototype.configs = null;

    function ssUnitMarkupBuilder(categories, configs) {
      var allButton, category, index, markupHash, _i, _len;
      this.configs = configs;
      categories.sort(function(a, b) {
        return a.name - b.name;
      });
      markupHash = [];
      for (index = _i = 0, _len = categories.length; _i < _len; index = ++_i) {
        category = categories[index];
        markupHash.push(this.buttonTemplate(category.id, category.name, this.configs));
      }
      allButton = " <div class='iui-size iui-view-all'>                    <a class='btn' href='" + (this.unitPageUrl()) + "/#/size'>                      View All                    </a>                  </div> ";
      markupHash.push(allButton);
      $('.ss-featured-unit-categories .iui-container').html(markupHash.join(''));
    }

    ssUnitMarkupBuilder.prototype.buttonTemplate = function(id, name, configs) {
      return "<div class='iui-size'><a class='btn' href='" + (this.unitPageUrl()) + "/#/options?categoryId=" + id + "'>" + name + "</a></div>";
    };

    ssUnitMarkupBuilder.prototype.unitPageUrl = function() {
      if (this.configs.unit_page_url.indexOf('http') !== -1) {
        return this.configs.unit_page_url;
      } else {
        return "" + document.location.href + "/" + this.configs.unit_page_url;
      }
    };

    return ssUnitMarkupBuilder;

  })();

}).call(this);
