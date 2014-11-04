(function() {
  var SearchButtonListener, SearchResultsList, SearchResultsMap, ZipSearchAjaxRequest, ZipSearchConfigs;

  $(function() {
    var zipSearchConfigs;
    zipSearchConfigs = new ZipSearchConfigs;
    new SearchButtonListener(zipSearchConfigs);
    return new ZipSearchAjaxRequest(zipSearchConfigs);
  });

  ZipSearchAjaxRequest = (function() {
    function ZipSearchAjaxRequest(zipSearchConfigs) {
      var _this = this;
      if (zipSearchConfigs.searchURL()) {
        $.ajax({
          url: zipSearchConfigs.searchURL(),
          dataType: 'json',
          success: function(data) {
            new SearchResultsList(zipSearchConfigs, data);
            return new SearchResultsMap(zipSearchConfigs, data);
          }
        });
      }
    }

    return ZipSearchAjaxRequest;

  })();

  SearchResultsMap = (function() {
    function SearchResultsMap(zipSearchConfigs, data) {
      var map, mapOptions, marker, myLatlng;
      $('.city-state-zip-search').append("<div id='map-canvas'></div>");
      myLatlng = new google.maps.LatLng(-25.363882, 131.044922);
      mapOptions = {
        zoom: 4,
        center: myLatlng
      };
      map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
      marker = new google.maps.Marker({
        position: myLatlng,
        map: map,
        title: 'Hello World!'
      });
    }

    return SearchResultsMap;

  })();

  SearchResultsList = (function() {
    function SearchResultsList(zipSearchConfigs, data) {
      this.zipSearchConfigs = zipSearchConfigs;
      this.data = data;
      this.populateResults();
    }

    SearchResultsList.prototype.populateResults = function() {
      var index, location, markupHash, _i, _len, _ref;
      markupHash = [];
      if (this.data.success) {
        markupHash.push("<p>We have " + this.data.locations.length + " locations near " + (this.zipSearchConfigs.searchArea()) + ":</p>");
      } else {
        markupHash.push("<p>Sorry, we don't have any locations in that area. Please try a different search, or see our full list of locations below:</p>");
      }
      _ref = this.data.locations;
      for (index = _i = 0, _len = _ref.length; _i < _len; index = ++_i) {
        location = _ref[index];
        markupHash.push("<div class='location-card'>");
        markupHash.push("<a href='" + location.domain + "'><p>" + location.name + "</p></a>                         <p>" + location.street_address_1 + "</p>                         <p>" + location.city + ", " + location.state + " " + location.postal_code + "</p>                         <p>" + location.phone_number + "</p>                         <p>" + location.domain + "</p> ");
        markupHash.push("</div>");
      }
      return $('.city-state-zip-search .search-results').html(markupHash.join(''));
    };

    return SearchResultsList;

  })();

  ZipSearchConfigs = (function() {
    function ZipSearchConfigs() {
      this.configs = JSON.parse($('#zip-search-config').html());
      this.search = this.getParameter('search');
      this.serviceURL = this.configs.serviceURL === "" ? "//g5-hub.herokuapp.com" : this.configs.serviceURL;
    }

    ZipSearchConfigs.prototype.getParameter = function(name) {
      var regex, results, value;
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      regex = new RegExp("[\\?&]" + name + "=([^&#]*)");
      results = regex.exec(location.search);
      return value = results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    };

    ZipSearchConfigs.prototype.searchURL = function() {
      var radius, searchURL;
      radius = this.getParameter("radius");
      if (this.search === "") {
        searchURL = null;
      } else {
        searchURL = "" + this.serviceURL + "/clients/" + this.configs.clientURN + "/location_search.json?";
        searchURL += "search=" + this.search;
        if (radius !== "") {
          searchURL += "&radius=" + radius;
        }
      }
      return searchURL;
    };

    ZipSearchConfigs.prototype.searchArea = function() {
      if (this.search) {
        return this.search.toUpperCase();
      } else {
        return "";
      }
    };

    return ZipSearchConfigs;

  })();

  SearchButtonListener = (function() {
    function SearchButtonListener(zipSearchConfigs) {
      var searchButton,
        _this = this;
      searchButton = $('.city-state-zip-search .zip-search-button');
      if (zipSearchConfigs.configs.searchResultsPage === "") {
        searchButton.click(function(event) {
          event.preventDefault();
          return _this.renderResultsInline(zipSearchConfigs);
        });
      } else {
        searchButton.click(function(event) {
          event.preventDefault();
          return _this.bumpToSearchPage(zipSearchConfigs);
        });
      }
    }

    SearchButtonListener.prototype.userInput = function() {
      return $('.zip-search-form input[name=search]').val();
    };

    SearchButtonListener.prototype.renderResultsInline = function(zipSearchConfigs) {
      zipSearchConfigs.search = this.userInput();
      return new ZipSearchAjaxRequest(zipSearchConfigs);
    };

    SearchButtonListener.prototype.bumpToSearchPage = function(zipSearchConfigs) {
      var radius, search, searchURL;
      radius = zipSearchConfigs.getParameter("radius");
      search = this.userInput() === "" ? "blank" : this.userInput();
      searchURL = zipSearchConfigs.configs.searchResultsPage;
      searchURL += "?search=" + search;
      return window.location = searchURL;
    };

    return SearchButtonListener;

  })();

}).call(this);
