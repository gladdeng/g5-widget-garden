(function() {
  var errorCallback, getClientCoords, getStoreCoords, loadScript, populateStartAddress, setupMap, storeCoords, successCallback;

  loadScript = function() {
    var script;
    script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=true&callback=initializeDirections";
    return document.body.appendChild(script);
  };

  window.initializeDirections = function() {
    getStoreCoords();
    return getClientCoords();
  };

  setupMap = function() {
    var map, mapOptions;
    window.directionsDisplay = new google.maps.DirectionsRenderer();
    mapOptions = {
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: storeCoords
    };
    map = new google.maps.Map($("#directions .canvas")[0], mapOptions);
    window.directionsDisplay.setMap(map);
    return window.directionsDisplay.setPanel($("#directions .panel")[0]);
  };

  getStoreCoords = function() {
    return $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: directionsConfig.address,
      sensor: "false"
    }).done(function(data) {
      window.lat = data.results[0].geometry.location.lat;
      window.lng = data.results[0].geometry.location.lng;
      window.storeCoords = new google.maps.LatLng(window.lat, window.lng);
      return setupMap();
    });
  };

  getClientCoords = function() {
    var geoloc, nav, watchID;
    watchID = void 0;
    nav = window.navigator;
    if (nav != null) {
      geoloc = nav.geolocation;
      return watchID = geoloc.getCurrentPosition(successCallback, errorCallback);
    }
  };

  successCallback = function(position) {
    var coords;
    coords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    return populateStartAddress(coords);
  };

  errorCallback = function(error) {
    return console.log("error detecting physical location");
  };

  populateStartAddress = function(latLng) {
    var address, geocoder;
    address = void 0;
    geocoder = new google.maps.Geocoder();
    return geocoder.geocode({
      latLng: latLng
    }, function(results, status) {
      if (status === google.maps.GeocoderStatus.OK) {
        address = results[0].formatted_address;
        return $("#start").attr("value", address);
      }
    });
  };

  window.calcRoute = function() {
    var directionsService, end, request, start;
    directionsService = new google.maps.DirectionsService();
    start = document.getElementById("start").value;
    end = window.storeCoords;
    request = {
      origin: start,
      destination: end,
      travelMode: google.maps.TravelMode.DRIVING
    };
    return directionsService.route(request, function(result, status) {
      if (status === google.maps.DirectionsStatus.OK) {
        return window.directionsDisplay.setDirections(result);
      }
    });
  };

  storeCoords = void 0;

  $(function() {
    window.directionsConfig = JSON.parse($('#directions .config:first').html());
    return loadScript();
  });

}).call(this);
