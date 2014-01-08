window.initializeMap = ->
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    address: widgetMapConfig.address
    sensor: "false"
  ).done (data) ->
    coordinates = data.results[0].geometry.location
    setMap(coordinates)

loadScript = ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initializeMap"
  document.body.appendChild script

setMap = (coordinates) ->
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
  map = new google.maps.Map($("#map .canvas")[0], mapOptions)
  marker.setMap map

$ ->
  window.widgetMapConfig = JSON.parse($('#map .config:first').html())
  loadScript()
