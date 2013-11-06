loadScript = ->
  script = document.createElement("script")
  script.type = "text/javascript"
  script.src = "http://maps.googleapis.com/maps/api/js?sensor=true&callback=initializeDirections"
  document.body.appendChild script

window.initializeDirections = ->
  getStoreCoords()
  getClientCoords()

setupMap = ->
  window.directionsDisplay = new google.maps.DirectionsRenderer()
  mapOptions =
    zoom: 15
    mapTypeId: google.maps.MapTypeId.ROADMAP
    center: storeCoords

  map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
  window.directionsDisplay.setMap map
  window.directionsDisplay.setPanel document.getElementById("directionsPanel")

getStoreCoords = ->
  $.getJSON("http://maps.googleapis.com/maps/api/geocode/json",
    address: directionsConfig.address
    sensor: "false"
  ).done (data) ->
    window.lat = data.results[0].geometry.location.lat
    window.lng = data.results[0].geometry.location.lng
    window.storeCoords = new google.maps.LatLng(window.lat, window.lng)
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

window.calcRoute = ->
  directionsService = new google.maps.DirectionsService()
  start = document.getElementById("start").value
  end = window.storeCoords
  request =
    origin: start
    destination: end
    travelMode: google.maps.TravelMode.DRIVING

  directionsService.route request, (result, status) ->
    window.directionsDisplay.setDirections result  if status is google.maps.DirectionsStatus.OK

storeCoords = undefined

$ ->
  window.directionsConfig = JSON.parse($('#directions-config:first').html())
  loadScript()
