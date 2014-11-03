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

    $('.city-state-zip-search').append(markupHash.join(''))

class ZipSearchConfigs
  constructor: () ->
    @configs = JSON.parse($('#zip-search-config').html())

  getParameter: (name) ->
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
    regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
    results = regex.exec(location.search)
    value = if results == null then "" else decodeURIComponent(results[1].replace(/\+/g, " "))

  searchURL: () ->
    search = @getParameter("search")
    radius = @getParameter("radius")

    if search == ""
      searchURL = null
    else
      searchURL = "#{@configs.serviceURL}/clients/#{@configs.clientURN}/location_search.json?"
      searchURL += "search=#{search}"
      searchURL += "&radius=#{radius}" if radius != ""
    
    searchURL

  searchArea: () ->
    search = @getParameter('search')

    if search
      search.toUpperCase()
    else
      ""

class SearchButtonListener
  constructor: (@zipSearchConfigs) ->
    # set up the listener for the search button
    # account for mini and full versions
    alert "POW!"



  




