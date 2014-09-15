(function() {
  var iuiMarkupBuilder,
    _this = this;

  $.ajax({
    url: 'http://www.g5api.com/api/v0/multi_families?store_id=7337',
    dataType: 'json',
    success: function(data) {
      var categories;
      categories = data.unit_categories;
      if (typeof categories !== "undefined" && categories.length > 0) {
        return new iuiMarkupBuilder(categories);
      }
    }
  });

  iuiMarkupBuilder = (function() {
    var buttonTemplate;

    function iuiMarkupBuilder(categories) {
      var category, index, markupHash, _i, _len;
      markupHash = [];
      for (index = _i = 0, _len = categories.length; _i < _len; index = ++_i) {
        category = categories[index];
        markupHash.push(buttonTemplate(category.beds));
      }
      $('#googus').append(markupHash.join(''));
    }

    buttonTemplate = function(beds) {
      return "<h3>" + beds + "</h3>";
    };

    return iuiMarkupBuilder;

  })();

}).call(this);
