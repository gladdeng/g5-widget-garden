(function() {
  var getCoords, setMap;

  window.getHumanDirectionsCoords = function() {
    return getCoords();
  };

  getCoords = function() {
    return $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: widgetHumanDirectionsConfig.address,
      sensor: "false"
    }).done(function(data) {
      var coordinates;
      coordinates = data.results[0].geometry.location;
      return setMap(coordinates);
    });
  };

  setMap = function(coordinates) {
    var lat, latLng, lng, map, mapOptions, marker, markerOptions;
    lat = coordinates.lat;
    lng = coordinates.lng;
    latLng = new google.maps.LatLng(lat, lng);
    mapOptions = {
      scrollwheel: widgetHumanDirectionsConfig.panZoom,
      draggable: widgetHumanDirectionsConfig.panZoom,
      disableDefaultUI: !widgetHumanDirectionsConfig.panZoom,
      disableDoubleClickZoom: !widgetHumanDirectionsConfig.panZoom,
      zoom: 18,
      center: latLng,
      mapTypeId: google.maps.MapTypeId[widgetHumanDirectionsConfig.mapType]
    };
    markerOptions = {
      position: latLng
    };
    marker = new google.maps.Marker(markerOptions);
    map = new google.maps.Map($(".human-directions .canvas")[0], mapOptions);
    return marker.setMap(map);
  };

  $(function() {
    return window.widgetHumanDirectionsConfig = JSON.parse($('.human-directions .config:first').html());
  });

}).call(this);
