var coordinates;

function initialize() {
  lat = coordinates.lat;
  lng = coordinates.lng;
  var latLng = new google.maps.LatLng(lat, lng);
  var mapOptions = {
    scrollwheel: widgetHumanDirectionsConfig.panZoom,
    draggable: widgetHumanDirectionsConfig.panZoom,
    disableDefaultUI: !widgetHumanDirectionsConfig.panZoom,
    disableDoubleClickZoom: !widgetHumanDirectionsConfig.panZoom,
    zoom: 18,
    center: latLng,
    mapTypeId: google.maps.MapTypeId[widgetHumanDirectionsConfig.mapType]
  };
  var markerOptions = {
    position: latLng
  };
  var marker = new google.maps.Marker(markerOptions);
  var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
  marker.setMap(map);
}

function loadScript() {
  var script  = document.createElement("script");
  script.type = "text/javascript";
  script.src  = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initialize";
  document.body.appendChild(script);
}

function getCoordinates() {
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    { address: widgetHumanDirectionsConfig.address, sensor: "false" }).done(function(data) {
      coordinates = data.results[0].geometry.location;
      loadScript();
    });
}

$(function() { getCoordinates(); });
