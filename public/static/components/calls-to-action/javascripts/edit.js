(function() {
  window.UniqueSelectValues = (function() {
    function UniqueSelectValues(selects) {
      var _this = this;

      this.selects = selects;
      this.disableOptions();
      this.selects.change(function() {
        return _this.disableOptions();
      });
    }

    UniqueSelectValues.prototype.disableOptions = function() {
      var select, _i, _len, _ref, _results;

      this.enableAll();
      _ref = this.selects;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        select = _ref[_i];
        if (select.value !== '') {
          _results.push(this.makeDisabled(select));
        }
      }
      return _results;
    };

    UniqueSelectValues.prototype.enableAll = function() {
      var option, _i, _len, _ref, _results;

      _ref = this.selects.children();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        option = _ref[_i];
        if (option.disabled) {
          _results.push($(option).removeAttr('disabled'));
        }
      }
      return _results;
    };

    UniqueSelectValues.prototype.makeDisabled = function(select) {
      var options;

      options = this.selects.not(select).children("[value='" + select.value + "']");
      return options.attr('disabled', 'disabled');
    };

    return UniqueSelectValues;

  })();

}).call(this);
