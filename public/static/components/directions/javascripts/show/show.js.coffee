loadScript = ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?sensor=true&callback=initialize"
  document.body.appendChild script

initialize = ->
  getStoreCoords()
  getClientCoords()

setupMap = ->
  directionsDisplay = new google.maps.DirectionsRenderer()
  mapOptions =
    zoom: 15
    mapTypeId: google.maps.MapTypeId.ROADMAP
    center: storeCoords

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  directionsDisplay.setMap map
  directionsDisplay.setPanel document.getElementById("directionsPanel")

getStoreCoords = ->
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    address: widgetMapConfig.address
    sensor: "false"
  ).done (data) ->
    storeCoords = data.results[0].geometry.location
    storeCoords = new google.maps.LatLng(storeCoords.lat, storeCoords.lng)
    setupMap()

getClientCoords = ->
  watchID = undefined
  nav = window.navigator
  if nav?
    geoloc = nav.geolocation
    watchID = geoloc.getCurrentPosition(successCallback, errorCallback)

successCallback = (position) ->
  coords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
  populateStartAddress coords

errorCallback = (error) ->
  console.log "error detecting physical location"

populateStartAddress = (latLng) ->
  address = undefined
  geocoder = new google.maps.Geocoder()
  geocoder.geocode
    latLng: latLng,
    (results, status) ->
    if status is google.maps.GeocoderStatus.OK
      address = results[0].formatted_address
      $("#start").attr "value", address

calcRoute = ->
  directionsService = new google.maps.DirectionsService()
  start = document.getElementById("start").value
  end = storeCoords
  request =
    origin: start
    destination: end
    travelMode: google.maps.TravelMode.DRIVING

  directionsService.route request, (result, status) ->
    directionsDisplay.setDirections result  if status is google.maps.DirectionsStatus.OK

directionsDisplay = undefined
map = undefined
storeCoords = undefined

$ ->
  loadScript()
