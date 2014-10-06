$ ->

  miniSearchConfigs = JSON.parse($('#mf-mini-search-config').html())

  $.ajax
    url: "#{miniSearchConfigs.serviceURL}/api/v0/client_locations?client_id=#{miniSearchConfigs.clientID}"
    dataType: 'json'
    success: (data) =>
      new corpSearchMarkupBuilder(data, miniSearchConfigs) 
      $('.mf-search-go-button').on('click', -> new searchSubmittal(data, miniSearchConfigs))

class corpSearchMarkupBuilder
  constructor: (data, configs) ->
    stateSelect = $('.multifamily-mini-search select.mf-search-states')
    citySelect = $('.multifamily-mini-search select.mf-search-cities')
    new optionsBuilder(data.states, stateSelect)

    stateSelect.change -> new citySelectUpdater(data, stateSelect, citySelect)
    
class citySelectUpdater 
  constructor: (data, stateSelect, citySelect) ->
    # reset the values in the city select
    citySelect.html("<option value=''>City</option>")
    # get the currently selected state
    selectedState = stateSelect.val()
    # build an array of currently relevant cities
    relevantCities = data.cities.filter((city) -> city.state_id == parseInt(selectedState,10))
    # update the select options 
    new optionsBuilder(relevantCities, citySelect)

class optionsBuilder
  constructor: (options, element) ->
    markupHash = []
    for option, index in options
      markupHash.push("<option value='#{option.id}'>#{option.name}</option>")

    element.append(markupHash.join(''))

class searchSubmittal
  constructor: (data, miniSearchConfigs) ->
    selectedState = $('.multifamily-mini-search select.mf-search-states').val()
    selectedCity = $('.multifamily-mini-search select.mf-search-cities').val()

    stateObject = data.states.filter((state) -> state.id == parseInt(selectedState,10))
    stateParam = if typeof(stateObject[0]) != "undefined" then stateObject[0].name else "null"

    cityObject = data.cities.filter((city) -> city.id == parseInt(selectedCity,10))
    cityParam = if typeof(cityObject[0]) != "undefined" then cityObject[0].name else "null"

    queryString = "?city=#{cityParam}&neighborhood=null&page=1&state=#{stateParam}"

  