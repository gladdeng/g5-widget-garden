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

class SearchResultsMap
  constructor: (zipSearchConfigs, data) ->

    $('.city-state-zip-search').append("<div id='map-canvas'></div>")
    
    myLatlng = new google.maps.LatLng(-25.363882,131.044922);
    mapOptions = {
      zoom: 4
      center: myLatlng
    }

    map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions)

    marker = new google.maps.Marker({
      position: myLatlng
      map: map
      title: 'Hello World!'
    })

  
class SearchResultsList
  constructor: (@zipSearchConfigs, @data) ->
    @populateResults()

  populateResults: () ->
    markupHash = []

    if @data.success
      markupHash.push("<p>We have #{@data.locations.length} locations near #{ @zipSearchConfigs.searchArea() }:</p>")
    else
      markupHash.push("<p>Sorry, we don't have any locations in that area. Please try a different search, or see our full list of locations below:</p>")

    for location, index in @data.locations
      markupHash.push("<div class='location-card'>")
      markupHash.push(  "<a href='#{location.domain}'><p>#{location.name}</p></a>
                         <p>#{location.street_address_1}</p>
                         <p>#{location.city}, #{location.state} #{location.postal_code}</p>
                         <p>#{location.phone_number}</p>
                         <p>#{location.domain}</p> ")
      markupHash.push("</div>")

    $('.city-state-zip-search .search-results').html(markupHash.join(''))

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
