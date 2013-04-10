var coordinates;

function initialize() {
  lat = coordinates.lat;
  lng = coordinates.lng;
  var mapOptions = {
    scrollwheel: widgetMapConfig.panZoom,
    draggable: widgetMapConfig.panZoom,
    disableDefaultUI: !widgetMapConfig.panZoom,
    disableDoubleClickZoom: !widgetMapConfig.panZoom,
    zoom: 18,
    center: new google.maps.LatLng(lat, lng),
    mapTypeId: google.maps.MapTypeId[widgetMapConfig.mapType]
  };
  var map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
}

function loadScript() {
  var script  = document.createElement("script");
  script.type = "text/javascript";
  script.src  = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initialize";
  document.body.appendChild(script);
}

function getCoordinates() {
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    { address: widgetMapConfig.address, sensor: "false" }).done(function(data) {
      coordinates = data.results[0].geometry.location;
      loadScript();
    });
}

$(function() { getCoordinates(); });
