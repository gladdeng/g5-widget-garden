$ ->

  miniSearchConfigs = JSON.parse($('#mf-mini-search-config').html())

  $.ajax
    url: "#{miniSearchConfigs.serviceURL}/api/v0/client_locations?client_id=#{miniSearchConfigs.clientID}"
    dataType: 'json'
    success: (data) =>
      new corpSearchMarkupBuilder(data, miniSearchConfigs) 


class corpSearchMarkupBuilder
  constructor: (data, configs) ->
    stateSelect = $('.multifamily-mini-search select.mf-search-states')
    new optionsBuilder(data.states, stateSelect)

    stateSelect.change( ->
      alert "POW!"
    )


    

class optionsBuilder
  constructor: (options, element) ->
    markupHash = []
    for option, index in options
      markupHash.push("<option value='#{option.name}'>#{option.name}</option>")

    element.append(markupHash.join(''))