(function() {
  var setMap;

  coordinates = new google.maps.LatLng(widgetAreaConfig.latitude, widgetAreaConfig.longitude);
  setMap(coordinates);

  setMap = function(latLng) {
    var map, mapOptions, marker, markerOptions;
    mapOptions = {
      scrollwheel: widgetMapConfig.panZoom,
      draggable: widgetMapConfig.panZoom,
      disableDefaultUI: !widgetMapConfig.panZoom,
      disableDoubleClickZoom: !widgetMapConfig.panZoom,
      zoom: 16,
      center: new google.maps.LatLng(lat, lng),
      mapTypeId: google.maps.MapTypeId[widgetMapConfig.mapType]
    };
    markerOptions = {
      position: latLng
    };
    marker = new google.maps.Marker(markerOptions);
    map = new google.maps.Map($(".map .canvas")[0], mapOptions);
    return marker.setMap(map);
  };

  $(function() {
    return window.widgetMapConfig = JSON.parse($('.map .config:first').html());
  });

}).call(this);
