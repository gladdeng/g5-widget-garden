(function() {
  var calcRoute, directionsDisplay, errorCallback, getClientCoords, getStoreCoords, initialize, loadScript, map, populateStartAddress, setupMap, storeCoords, successCallback;

  loadScript = function() {
    var script;
    script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=true&callback=initialize";
    return document.body.appendChild(script);
  };

  initialize = function() {
    getStoreCoords();
    return getClientCoords();
  };

  setupMap = function() {
    var directionsDisplay, map, mapOptions;
    directionsDisplay = new google.maps.DirectionsRenderer();
    mapOptions = {
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: storeCoords
    };
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    directionsDisplay.setMap(map);
    return directionsDisplay.setPanel(document.getElementById("directionsPanel"));
  };

  getStoreCoords = function() {
    return $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: directionsConfig.address,
      sensor: "false"
    }).done(function(data) {
      var storeCoords;
      storeCoords = data.results[0].geometry.location;
      storeCoords = new google.maps.LatLng(storeCoords.lat, storeCoords.lng);
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
    }, function(results, status) {}, status === google.maps.GeocoderStatus.OK ? (address = results[0].formatted_address, $("#start").attr("value", address)) : void 0);
  };

  calcRoute = function() {
    var directionsService, end, request, start;
    directionsService = new google.maps.DirectionsService();
    start = document.getElementById("start").value;
    end = storeCoords;
    request = {
      origin: start,
      destination: end,
      travelMode: google.maps.TravelMode.DRIVING
    };
    return directionsService.route(request, function(result, status) {
      if (status === google.maps.DirectionsStatus.OK) {
        return directionsDisplay.setDirections(result);
      }
    });
  };

  directionsDisplay = void 0;

  map = void 0;

  storeCoords = void 0;

  $(function() {
    window.directionsConfig = JSON.parse($('#directions-config:first').html());
    return loadScript();
  });

}).call(this);
