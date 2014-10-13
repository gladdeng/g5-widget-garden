(function() {
  var citySelectUpdater, corpSearchMarkupBuilder, optionsBuilder, searchSubmittal;

  $(function() {
    var miniSearchConfigs, radioButtons,
      _this = this;
    miniSearchConfigs = JSON.parse($('#mf-mini-search-config').html());
    $.ajax({
      url: "" + miniSearchConfigs.serviceURL + "/api/v0/client_locations?client_id=" + miniSearchConfigs.clientID,
      dataType: 'json',
      success: function(data) {
        new corpSearchMarkupBuilder(data, miniSearchConfigs);
        return $('.mf-search-go-button').on('click', function() {
          return new searchSubmittal(data, miniSearchConfigs);
        });
      }
    });
    radioButtons = "<input type='radio' name='corp-search-type' id='default-search' value='default-search' checked>                  <label for='default-search'>" + miniSearchConfigs.defaultSearchOption + "</label>                  <input type='radio' name='corp-search-type' id='alternate-search' value='alternate-search'>                  <label for='alternate-search'>" + miniSearchConfigs.alternateSearchOption + "</label>";
    return $(radioButtons).insertAfter($('.multifamily-mini-search h2'));
  });

  corpSearchMarkupBuilder = (function() {
    function corpSearchMarkupBuilder(data, configs) {
      var citySelect, stateSelect;
      stateSelect = $('.multifamily-mini-search select.mf-search-states');
      citySelect = $('.multifamily-mini-search select.mf-search-cities');
      new optionsBuilder(data.states, stateSelect);
      stateSelect.change(function() {
        return new citySelectUpdater(data, stateSelect, citySelect);
      });
    }

    return corpSearchMarkupBuilder;

  })();

  citySelectUpdater = (function() {
    function citySelectUpdater(data, stateSelect, citySelect) {
      var relevantCities, selectedState;
      citySelect.html("<option value=''>City</option>");
      selectedState = stateSelect.val();
      relevantCities = data.cities.filter(function(city) {
        return city.state_id === parseInt(selectedState, 10);
      });
      new optionsBuilder(relevantCities, citySelect);
    }

    return citySelectUpdater;

  })();

  optionsBuilder = (function() {
    function optionsBuilder(options, element) {
      var index, markupHash, option, _i, _len;
      markupHash = [];
      for (index = _i = 0, _len = options.length; _i < _len; index = ++_i) {
        option = options[index];
        markupHash.push("<option value='" + option.id + "'>" + option.name + "</option>");
      }
      element.append(markupHash.join(''));
    }

    return optionsBuilder;

  })();

  searchSubmittal = (function() {
    function searchSubmittal(data, miniSearchConfigs) {
      var cityObject, cityParam, queryString, selectedCity, selectedState, stateObject, stateParam;
      selectedState = $('.multifamily-mini-search select.mf-search-states').val();
      selectedCity = $('.multifamily-mini-search select.mf-search-cities').val();
      stateObject = data.states.filter(function(state) {
        return state.id === parseInt(selectedState, 10);
      });
      stateParam = typeof stateObject[0] !== "undefined" ? "&state=" + stateObject[0].name : "";
      cityObject = data.cities.filter(function(city) {
        return city.id === parseInt(selectedCity, 10);
      });
      cityParam = typeof cityObject[0] !== "undefined" ? "&city=" + cityObject[0].name : "";
      queryString = "?page=1" + stateParam + cityParam;
      if ($('input[name=corp-search-type]:checked').val() === 'alternate-search') {
        window.location = miniSearchConfigs.externalSearchURL;
      } else {
        window.location = "//" + window.location.host + miniSearchConfigs.corpSearchPage + queryString;
      }
    }

    return searchSubmittal;

  })();

}).call(this);
