window.getDirectionsCoords = ->
  getStoreCoords()
  getClientCoords()

setupMap = ->
  window.directionsDisplay = new google.maps.DirectionsRenderer()
  mapOptions =
    zoom: 15
    mapTypeId: google.maps.MapTypeId.ROADMAP
    center: storeCoords

  map = new google.maps.Map($(".directions .canvas")[0], mapOptions)
  window.directionsDisplay.setMap map
  window.directionsDisplay.setPanel $(".directions .panel")[0]

getStoreCoords = ->
  $.getJSON("https://maps.googleapis.com/maps/api/geocode/json",
    address: directionsConfig.address
    sensor: "false"
  ).done (data) ->
    if data.results.length
      window.lat = data.results[0].geometry.location.lat
      window.lng = data.results[0].geometry.location.lng
      window.storeCoords = new google.maps.LatLng(window.lat, window.lng)
      setupMap()
    else
      showErrorMessage "The Store address for this Directions Widget is not set up correctly"

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
  showErrorMessage "Phyical location for the starting address not found"
  console.log "error detecting physical location"

showErrorMessage = (message) ->
  $(".directions-error").html(message).addClass('show') if message.length

hideErrorMessage = ->
  $(".directions-error").removeClass 'show'

populateStartAddress = (latLng) ->
  address = undefined
  geocoder = new google.maps.Geocoder()
  geocoder.geocode
    latLng: latLng,
    (results, status) ->
      if status is google.maps.GeocoderStatus.OK
        address = results[0].formatted_address
        $("#start").attr "value", address
        calcRoute();

window.calcRoute = ->
  hideErrorMessage
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
  window.directionsConfig = JSON.parse($('.directions .config:first').html());
  $('.directions input[type="submit"]').on 'click', ->
    calcRoute()
