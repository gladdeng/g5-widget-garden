$ ->

  miniSearchConfigs = JSON.parse($('#mf-mini-search-config').html())

  $.ajax
    url: "#{miniSearchConfigs.serviceURL}/api/v0/client_locations?client_id=#{miniSearchConfigs.clientID}"
    dataType: 'json'
    success: (data) =>
      new corpSearchMarkupBuilder(data, miniSearchConfigs) 
      $('.mf-search-go-button').on('click', -> new searchSubmittal(data, miniSearchConfigs))

  new radioButtonBuilder(miniSearchConfigs)


class radioButtonBuilder
  constructor: (configs) ->
    altSearchVals = [ configs.defaultSearchOption,
                      configs.alternateSearchOption,
                      configs.externalSearchURL ]

    if altSearchVals.indexOf('') == -1
      radioButtons = "<div class='search-type-radio-buttons'>
                        <input type='radio' name='corp-search-type' id='default-search' value='default-search' checked>
                        <label for='default-search'>#{configs.defaultSearchOption}</label>
                        <input type='radio' name='corp-search-type' id='alternate-search' value='alternate-search'>
                        <label for='alternate-search'>#{configs.alternateSearchOption}</label>
                      </div>"

      $(radioButtons).insertAfter($('.multifamily-mini-search h2'))

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
    stateParam = if typeof(stateObject[0]) != "undefined" then "&state=#{stateObject[0].name}" else ""

    cityObject = data.cities.filter((city) -> city.id == parseInt(selectedCity,10))
    cityParam = if typeof(cityObject[0]) != "undefined" then "&city=#{cityObject[0].name}" else ""

    queryString = "?page=1#{stateParam}#{cityParam}"
    
    radioButtons = $('input[name=corp-search-type]:checked')
    if radioButtons.length > 0 && radioButtons.val() == 'alternate-search'
      newWindow = window.open(miniSearchConfigs.externalSearchURL, '_blank');
      newWindow.focus();
    else
      window.location = "//#{window.location.host}#{miniSearchConfigs.corpSearchPage}#{queryString}"
