class pricingAndAvailability
  constructor: (pricingOptions) ->

    heroku_app_name_max_length = 30

    cpas_urn = pricingOptions["clientUrn"].replace(/-c-/, "-cpas-")
    cpas_urn = cpas_urn.substring(0, heroku_app_name_max_length)

    location_urn = pricingOptions["locationUrn"]

    if cpas_urn && location_urn
      @getPricing(cpas_urn, location_urn)

  getPricing: (cpas_urn, location_urn) ->

    pricingURL = "http://" + cpas_urn + ".herokuapp.com/locations/" + location_urn

    $.get pricingURL, (data) ->
      $(".floorplans").hide()
      $('[role=main]').append('<div id="loading-floorplans">Loading&hellip;</div>')

      $data = $(data)
      floorplans = $data.find('.e-content')

      $(".floorplans").append(floorplans).fadeIn()
      $('#loading-floorplans').fadeOut().delay(1000).remove()

      $(".filters input").on "change", (e) ->
        bedFilter = $('#beds-filter input:checked').val()
        bathFilter = $('#baths-filter input:checked').val()
        bedSelector = ''
        bathSelector = ''

        if bedFilter is 'beds-all' and bathFilter is 'baths-all'
          $('.floorplan').fadeIn()
        else
          bedSelector = '.' + bedFilter unless bedFilter is 'beds-all'
          bathSelector = '.' + bathFilter unless bathFilter is 'baths-all'
          $('.floorplan').fadeOut()
          $(bedSelector + bathSelector).fadeIn('fast')


$ ->
  pricingOptions = JSON.parse($('.floorplans .config:first').html())
  new pricingAndAvailability(pricingOptions)
  $(".floorplans .floorplan-btn").fancybox()

