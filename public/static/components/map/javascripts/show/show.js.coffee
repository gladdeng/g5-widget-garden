initialize = ->
  lat = coordinates.lat
  lng = coordinates.lng
  latLng = new google.maps.LatLng(lat, lng)
  mapOptions =
    scrollwheel: widgetMapConfig.panZoom
    draggable: widgetMapConfig.panZoom
    disableDefaultUI: not widgetMapConfig.panZoom
    disableDoubleClickZoom: not widgetMapConfig.panZoom
    zoom: 18
    center: new google.maps.LatLng(lat, lng)
    mapTypeId: google.maps.MapTypeId[widgetMapConfig.mapType]

  markerOptions = position: latLng
  marker = new google.maps.Marker(markerOptions)
  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  marker.setMap map

loadScript = ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initialize"
  document.body.appendChild script

getCoordinates = ->
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    address: widgetMapConfig.address
    sensor: "false"
  ).done (data) ->
    coordinates = data.results[0].geometry.location
    loadScript()

coordinates = undefined

$ ->
  getCoordinates()
