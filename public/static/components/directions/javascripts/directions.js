var directionsDisplay;
var map;
var storeCoords;

function loadScript() {
  var script = document.createElement("script");
  script.type = "text/javascript";
  script.src =
    "http://maps.googleapis.com/maps/api/js?sensor=true&callback=initialize";
  document.body.appendChild(script);
}

function initialize() {
  getStoreCoords();
  getClientCoords();
}

function setupMap(){
  directionsDisplay = new google.maps.DirectionsRenderer();
  var mapOptions = {
    zoom:15,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    center: storeCoords
  };
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
  directionsDisplay.setMap(map);
  directionsDisplay.setPanel(document.getElementById("directionsPanel"));
}

function getStoreCoords() {
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    { address: widgetMapConfig.address, sensor: "false" })
      .done(function(data) {
        storeCoords = data.results[0].geometry.location;
        storeCoords = new google.maps.LatLng(storeCoords.lat,
                                             storeCoords.lng);
        setupMap();
      });
}

function getClientCoords(){
  var watchID;
  var nav = window.navigator;
  if (nav != null) {
    var geoloc = nav.geolocation;
    watchID = geoloc.getCurrentPosition(successCallback, errorCallback);
  }
}

function successCallback(position) {
  var coords = new google.maps.LatLng(position.coords.latitude,
                                      position.coords.longitude);
  populateStartAddress(coords);
}

function errorCallback(error) {
  alert('error');
}

function populateStartAddress(latLng){
  var address;
  var geocoder = new google.maps.Geocoder();
  geocoder.geocode({'latLng': latLng}, function(results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
      address = results[0].formatted_address;
      $("#start").attr("value", address);
    }
  }); 
}

function calcRoute() {
  var directionsService = new google.maps.DirectionsService();
  var start = document.getElementById("start").value;
  var end = storeCoords;
  var request = {
    origin:start,
    destination:end,
    travelMode: google.maps.TravelMode.DRIVING
  };
  directionsService.route(request, function(result, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(result);
    }
  });
}

$(function(){
  loadScript();
})

