$ ->
  # Grab settings from index.html
  zipSearchConfigs = new ZipSearchConfigs
  # Set up listener for Search Button
  new SearchButtonListener(zipSearchConfigs)
  # Get search results from g5-hub
  new ZipSearchAjaxRequest(zipSearchConfigs)


class ZipSearchAjaxRequest
  constructor: (zipSearchConfigs) ->
    if zipSearchConfigs.searchURL()
      $.ajax
        url: zipSearchConfigs.searchURL()
        dataType: 'json'
        success: (data) =>
          new SearchResultsList(zipSearchConfigs, data)
          new SearchResultsMap(zipSearchConfigs, data)
          new ViewAllLink(zipSearchConfigs, data)

class SearchResultsMap
  constructor: (@zipSearchConfigs, @data) ->

    $('.city-state-zip-search').append("<div class='zip-search-map' id='map-canvas'></div>")
    @mapCanvas = $('.zip-search-map')[0]
    @bounds = new google.maps.LatLngBounds()
    @markers = []
    @infowindows = []

    mapOptions = {}

    @map = new google.maps.Map(@mapCanvas, mapOptions)

    @setMarkers(@data.locations)

    @map.fitBounds(@bounds)

  setMarkers: (locations) ->
    markers=[]
    infowindows=[]

    openInfoWindow = (index) ->
      infowindows[index].open(@map, markers[index])

    for location, index in locations
      lat = location.latitude
      long = location.longitude

      # Markers
      coordinates = new google.maps.LatLng(lat,long)
      marker = new google.maps.Marker({
        position: coordinates
        map: @map
        index: index
      })
      markers.push(marker)
      @bounds.extend(marker.position)

      # Info Windows
      infowindow = new google.maps.InfoWindow({ content: @infoWindowContent(location) })
      infowindows.push(infowindow)
      google.maps.event.addListener(markers[index],'click', ->
        infowindows[this.index].open(@map, markers[this.index])
      )

  infoWindowContent: (location) ->
    " <a href='#{location.domain}'>
        <h2>#{location.name}</h2>
      </a>
      <p>
        #{location.street_address_1}<br />
        #{location.city}, #{location.state} #{location.postal_code}<br />
        #{location.phone_number}
      </p> "

class SearchResultsList
  constructor: (@zipSearchConfigs, @data) ->
    @populateResults()

  populateResults: () ->
    markupHash = []

    if @data.success
      markupHash.push("<p class='zip-search-summary'>We have #{@data.locations.length} locations near #{ @zipSearchConfigs.searchArea() }:</p>")
    else
      markupHash.push("<p class='zip-search-summary'>Sorry, we don't have any locations in that area. Please try a different search, or see our full list of locations below:</p>")

    for location, index in @data.locations
      markupHash.push("<div class='zip-search-location'>")
      markupHash.push( "<img src='#{location.thumbnail}' />
                        <div class='location-address'>
                          <a href='#{location.domain}'><span class='branded-name'>#{location.name}<span></a>
                          <span class='street'>#{location.street_address_1}</span>
                          <span class='city'>#{location.city}, #{location.state} #{location.postal_code}</span>
                          <span class='phone'>#{location.phone_number}</span>
                        </div>
                        <a class='zip-search-location-link' href='#{location.domain}'>Visit Location</a> ")
      markupHash.push("</div>")

    $('.city-state-zip-search .zip-search-results').html(markupHash.join(''))

class ZipSearchConfigs
  constructor: () ->
    @configs = JSON.parse($('#zip-search-config').html())
    @search = @getParameter('search')
    @serviceURL = if @configs.serviceURL == "" then "//g5-hub.herokuapp.com" else @configs.serviceURL

  getParameter: (name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(location.search)
    value = if results == null then "" else decodeURIComponent(results[1].replace(/\+/g, " "))

  searchURL: () ->
    radius = @getParameter("radius")

    if @search == ""
      searchURL = null
    else
      searchURL = "#{@serviceURL}/clients/#{@configs.clientURN}/location_search.json?"
      searchURL += "search=#{@search}"
      searchURL += "&radius=#{radius}" if radius != ""
    
    searchURL

  searchArea: () ->
    if @search
      @search.toUpperCase()
    else
      ""

class SearchButtonListener
  constructor: (zipSearchConfigs) ->
    searchButton = $('.city-state-zip-search .zip-search-button')

    if zipSearchConfigs.configs.searchResultsPage == ""
      # No searchResultsPage means we stay here on submit
      searchButton.click( (event) =>
        event.preventDefault() 
        @renderResultsInline(zipSearchConfigs) )
    else
      # If searchResultsPage is populated, submit to that page
      searchButton.click( (event) =>
        event.preventDefault() 
        @bumpToSearchPage(zipSearchConfigs) )

  userInput: () ->
    $('.zip-search-form input[name=search]').val()
      
  renderResultsInline: (zipSearchConfigs) ->
    zipSearchConfigs.search = @userInput()
    new ZipSearchAjaxRequest(zipSearchConfigs)

  bumpToSearchPage: (zipSearchConfigs) ->
    radius = zipSearchConfigs.getParameter("radius")
    search = if @userInput() == "" then "blank" else @userInput()
    searchURL = zipSearchConfigs.configs.searchResultsPage
    searchURL += "?search=#{search}"
    window.location = searchURL

class ViewAllLink
  constructor: (zipSearchConfigs, data) ->
    if data.success
      linkMarkup = "<a href='#' class='view-all-link'>View All Locations</a>"
      $('.zip-search-results').append(linkMarkup)

      @createButtonListener(zipSearchConfigs)

  createButtonListener: (zipSearchConfigs) ->
    $('.view-all-link').click( (event) =>
      event.preventDefault() 
      zipSearchConfigs.search = "all"
      new ZipSearchAjaxRequest(zipSearchConfigs) )


    

