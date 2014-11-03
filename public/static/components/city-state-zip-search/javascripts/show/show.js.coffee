$ ->
  zipSearchConfigs = new ZipSearchConfigs
  new SearchButtonListener(zipSearchConfigs)
  new ZipSearchAjaxRequest(zipSearchConfigs)

class ZipSearchAjaxRequest
  constructor: (zipSearchConfigs) ->
    if zipSearchConfigs.searchURL()
      $.ajax
        url: zipSearchConfigs.searchURL()
        dataType: 'json'
        success: (data) =>
          new SearchResultsList(zipSearchConfigs, data)
  
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
      markupHash.push("<div>")
      markupHash.push(" <p>#{location.name}</p>
                        <p>#{location.street_address_1}</p>
                        <p>#{location.city}</p>
                        <p>#{location.state}</p>
                        <p>#{location.domain}</p> ")
      markupHash.push("</div>")

    $('.city-state-zip-search .search-results').html(markupHash.join(''))

class ZipSearchConfigs
  constructor: () ->
    @configs = JSON.parse($('#zip-search-config').html())
    @search = @getParameter('search')

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
      searchURL = "#{@configs.serviceURL}/clients/#{@configs.clientURN}/location_search.json?"
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
    zipSearchConfigs.search = @userInput
    new ZipSearchAjaxRequest(zipSearchConfigs)

  bumpToSearchPage: (zipSearchConfigs) ->
    radius = zipSearchConfigs.getParameter("radius")
    searchURL = zipSearchConfigs.configs.searchResultsPage
    searchURL += "?search=#{@userInput()}"
    window.location = searchURL
    
    



  




