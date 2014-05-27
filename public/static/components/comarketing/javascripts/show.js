(function() {
  var googleMaps = {};
  widgetAreaConfig = JSON.parse($('.comarketing .config:first').html());

  window.getComarketingCoords = function() {
    $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: widgetAreaConfig.address,
      sensor: "false"
    }).done(function(data) {
      var coordinates;
      coordinates = data.results[0].geometry.location;
      setMap(coordinates);

      googleMaps.latlngbounds = new google.maps.LatLngBounds();
      for (var i=0; i < widgetAreaConfig.addresses.length; i++){
        setMapMarker(widgetAreaConfig.addresses[i]);
      }
      googleMaps.map.fitBounds(googleMaps.latlngbounds);
    });
  };

  setMapMarker = function(address){
    $.getJSON("http://maps.googleapis.com/maps/api/geocode/json", {
      address: address,
      sensor: "false"
    }).done(function(data) {
      coordinates = data.results[0].geometry.location;
      var latlng = new google.maps.LatLng(coordinates.lat, coordinates.lng)

      locationMarker = new google.maps.Marker({
        position: latlng,
        map: googleMaps.map,
        title: address
      });
      googleMaps.latlngbounds.extend(latlng);
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
    googleMaps.map = new google.maps.Map($(".comarketing .canvas")[0], mapOptions);

    return marker.setMap(map);
  };
})();
