class pricingAndAvailability
  constructor: (pricingOptions) ->

    cpas_urn = pricingOptions["clientUrn"].replace(/^-c-/, "-cpas-")
    location_urn = pricingOptions["locationUrn"]

    if cpas && location_urn
      @getPricing(cpas_urn, location_urn)

  getPricing: (client_urn, location_urn) ->
    pricingURL = "http://" + cpas_urn + ".herokuapp.com/locations/" + location_urn;

    $.get pricingURL, (data) ->
      $data = $(data)
      floorplans = $data.find('.e-content')
      $("#floorplans").append(floorplans);

$ ->
  pricingOptions = JSON.parse($('#pricing-service-config:first').html())
  new pricingAndAvailability(pricingOptions)
