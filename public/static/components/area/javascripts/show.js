window.onload = function() {
  var googleMaps = {};
  widgetAreaConfig = JSON.parse($('.area .config:first').html());

  window.getMapCoords = function() {
    return $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: widgetAreaConfig.address,
      sensor: "false"
    }).done(function(data) {
      var coordinates;
      coordinates = data.results[0].geometry.location;
      return setMap(coordinates);
    });
  };

  setMapMarker = function(address){
    locationMarker = new google.maps.Marker({
      position: coordinates,
      map: googleMaps.map,
      title: 'Teh Location'
    });
    $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: address,
      sensor: "false"
    }).done(function(data) {
      var coordinates;
      coordinates = data.results[0].geometry.location;
    });
  }

  setMap = function(coordinates) {
    var lat, latLng, lng, map, mapOptions, marker, markerOptions;
    lat = coordinates.lat;
    lng = coordinates.lng;
    latLng = new google.maps.LatLng(lat, lng);
    mapOptions = {
      scrollwheel: widgetAreaConfig.panZoom,
      draggable: widgetAreaConfig.panZoom,
      disableDefaultUI: !widgetAreaConfig.panZoom,
      disableDoubleClickZoom: !widgetAreaConfig.panZoom,
      zoom: 16,
      center: new google.maps.LatLng(lat, lng),
      mapTypeId: google.maps.MapTypeId[widgetAreaConfig.mapType]
    };
    markerOptions = {
      position: latLng
    };
    marker = new google.maps.Marker(markerOptions);
    googleMaps.map = new google.maps.Map($(".map .canvas")[0], mapOptions);


    return marker.setMap(map);
  };
  setMapMarker("2800 W Pico Blvd Los Angeles, CA 90006");
};

