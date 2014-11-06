(function() {
  var errorCallback, getClientCoords, getStoreCoords, hideErrorMessage, invalidStoreAddressError, populateStartAddress, setupMap, showErrorMessage, storeCoords, successCallback;

  window.getDirectionsCoords = function() {
    getStoreCoords();
    return getClientCoords();
  };

  window.resizeDirectionsInput = function() {
    var startInput, startSubmit, startWrapper;
    startInput = $('.directions #start');
    startWrapper = startInput.parent('.text');
    startSubmit = startWrapper.find('input[type=submit]');
    return startInput.css({
      width: startWrapper.width() - startSubmit.outerWidth(true) - 10
    });
  };

  setupMap = function() {
    var map, mapMarkerOptions, mapOptions, marker;
    window.directionsDisplay = new google.maps.DirectionsRenderer();
    mapOptions = {
      zoom: 15,
      mapTypeId: google.maps.MapTypeId.ROADMAP,
      center: window.storeCoords
    };
    map = new google.maps.Map($(".directions .canvas")[0], mapOptions);
    window.directionsDisplay.setMap(map);
    window.directionsDisplay.setPanel($(".directions .panel")[0]);
    mapMarkerOptions = {
      position: window.storeCoords,
      map: map,
      title: directionsConfig.address
    };
    return marker = new google.maps.Marker(mapMarkerOptions);
  };

  getStoreCoords = function() {
    return $.getJSON("https://maps.googleapis.com/maps/api/geocode/json", {
      address: directionsConfig.address,
      sensor: "false"
    }).done(function(data) {
      if (data.results.length) {
        window.lat = data.results[0].geometry.location.lat;
        window.lng = data.results[0].geometry.location.lng;
        window.storeCoords = new google.maps.LatLng(window.lat, window.lng);
        return setupMap();
      } else {
        return invalidStoreAddressError();
      }
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
    showErrorMessage("Phyical location for the starting address not found");
    return console.log("error detecting physical location");
  };

  showErrorMessage = function(message) {
    if (message.length) {
      return $(".directions-error").html(message).addClass('show');
    }
  };

  hideErrorMessage = function() {
    return $(".directions-error").removeClass('show');
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
        $("#start").attr("value", address);
        return calcRoute();
      }
    });
  };

  window.calcRoute = function() {
    var directionsService, end, request, start;
    if (!window.storeCoords) {
      return invalidStoreAddressError();
    }
    hideErrorMessage();
    $('.directions input[type="submit"]').addClass('disabled').addClass('searching').prop('disabled', true);
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
        window.directionsDisplay.setDirections(result);
      } else {
        showErrorMessage("No directions found. Try a different address.");
      }
      return $('.directions input[type="submit"]').removeClass('disabled').addClass('searching').prop('disabled', false);
    });
  };

  invalidStoreAddressError = function() {
    showErrorMessage("The Store address for this Directions Widget is not set up correctly");
    $('.directions input[type=submit]').addClass('disabled').prop('disabled', true);
    $('.directions .canvas').hide();
    return $('.directions .panel').hide();
  };

  storeCoords = void 0;

  $(function() {
    window.directionsConfig = JSON.parse($('.directions .config:first').html());
    return $('.directions input[type="submit"]').on('click', function() {
      return calcRoute();
    });
  });

  $(window).on('load', function() {
    return resizeDirectionsInput();
  });

  $(window).on('resize', function() {
    return resizeDirectionsInput();
  });

}).call(this);
