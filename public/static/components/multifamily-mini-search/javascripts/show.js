(function() {
  var corpSearchMarkupBuilder, optionsBuilder;

  $(function() {
    var miniSearchConfigs,
      _this = this;
    miniSearchConfigs = JSON.parse($('#mf-mini-search-config').html());
    return $.ajax({
      url: "" + miniSearchConfigs.serviceURL + "/api/v0/client_locations?client_id=" + miniSearchConfigs.clientID,
      dataType: 'json',
      success: function(data) {
        return new corpSearchMarkupBuilder(data, miniSearchConfigs);
      }
    });
  });

  corpSearchMarkupBuilder = (function() {
    function corpSearchMarkupBuilder(data, configs) {
      var stateSelect;
      stateSelect = $('.multifamily-mini-search select.mf-search-states');
      new optionsBuilder(data.states, stateSelect);
      stateSelect.change(function() {
        return alert("POW!");
      });
    }

    return corpSearchMarkupBuilder;

  })();

  optionsBuilder = (function() {
    function optionsBuilder(options, element) {
      var index, markupHash, option, _i, _len;
      markupHash = [];
      for (index = _i = 0, _len = options.length; _i < _len; index = ++_i) {
        option = options[index];
        markupHash.push("<option value='" + option.name + "'>" + option.name + "</option>");
      }
      element.append(markupHash.join(''));
    }

    return optionsBuilder;

  })();

}).call(this);
