window.getHumanDirectionsCoords = ->
  getCoords()

getCoords = ->
  $.getJSON("https://maps.googleapis.com/maps/api/geocode/json",
    address: widgetHumanDirectionsConfig.address
    sensor: "false"
  ).done (data) ->
    coordinates = data.results[0].geometry.location
    setMap(coordinates)

setMap = (coordinates) ->
  lat = coordinates.lat
  lng = coordinates.lng
  latLng = new google.maps.LatLng(lat, lng)
  mapOptions =
    scrollwheel: widgetHumanDirectionsConfig.panZoom
    draggable: widgetHumanDirectionsConfig.panZoom
    disableDefaultUI: not widgetHumanDirectionsConfig.panZoom
    disableDoubleClickZoom: not widgetHumanDirectionsConfig.panZoom
    zoom: 18
    center: latLng
    mapTypeId: google.maps.MapTypeId[widgetHumanDirectionsConfig.mapType]

  markerOptions = position: latLng
  marker = new google.maps.Marker(markerOptions)
  map = new google.maps.Map($(".human-directions .canvas")[0], mapOptions)
  marker.setMap map

$ ->
  window.widgetHumanDirectionsConfig = JSON.parse($('.human-directions .config:first').html())
