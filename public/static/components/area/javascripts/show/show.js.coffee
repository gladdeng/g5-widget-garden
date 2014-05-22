center = new google.maps.LatLng(widgetAreaConfig.latitude, widgetAreaConfig.longitude),

setMap = (coordinates) ->
  lat = coordinates.lat
  lng = coordinates.lng
  latLng = new google.maps.LatLng(lat, lng)

  mapOptions =
    scrollwheel: widgetMapConfig.panZoom
    draggable: widgetMapConfig.panZoom
    disableDefaultUI: not widgetMapConfig.panZoom
    disableDoubleClickZoom: not widgetMapConfig.panZoom
    zoom: 16
    center: new google.maps.LatLng(lat, lng)
    mapTypeId: google.maps.MapTypeId[widgetMapConfig.mapType]

  markerOptions = position: latLng
  marker = new google.maps.Marker(markerOptions)
  map = new google.maps.Map($(".map .canvas")[0], mapOptions)
  marker.setMap map

$ ->
  window.widgetMapConfig = JSON.parse($('.map .config:first').html());
