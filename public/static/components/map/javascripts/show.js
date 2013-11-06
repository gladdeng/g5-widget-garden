(function() {
  var loadScript, setMap;

  window.initializeMap = function() {
    return $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: widgetMapConfig.address,
      sensor: "false"
    }).done(function(data) {
      var coordinates;
      coordinates = data.results[0].geometry.location;
      return setMap(coordinates);
    });
  };

  loadScript = function() {
    var script;
    script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initializeMap";
    return document.body.appendChild(script);
  };

  setMap = function(coordinates) {
    var lat, latLng, lng, map, mapOptions, marker, markerOptions;
    lat = coordinates.lat;
    lng = coordinates.lng;
    latLng = new google.maps.LatLng(lat, lng);
    mapOptions = {
      scrollwheel: widgetMapConfig.panZoom,
      draggable: widgetMapConfig.panZoom,
      disableDefaultUI: !widgetMapConfig.panZoom,
      disableDoubleClickZoom: !widgetMapConfig.panZoom,
      zoom: 18,
      center: new google.maps.LatLng(lat, lng),
      mapTypeId: google.maps.MapTypeId[widgetMapConfig.mapType]
    };
    markerOptions = {
      position: latLng
    };
    marker = new google.maps.Marker(markerOptions);
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
    return marker.setMap(map);
  };

  $(function() {
    window.widgetMapConfig = JSON.parse($('#map-config:first').html());
    return loadScript();
  });

}).call(this);
