class pricingAndAvailability
  constructor: (pricingOptions) ->

    client_urn = pricingOptions["clientUrn"].replace(/^g5-c-/, "g5-cpas-")
    location_urn = pricingOptions["locationUrn"]

    if client_urn && location_urn
      @getPricing(client_urn, location_urn)

  getPricing: (client_urn, location_urn) ->
    $.get "http://" + client_urn + ".herokuapp.com/locations/" + location_urn, (data) ->
      $data = $(data)
      floorplans = $data.find('.e-content')
      $("#floorplans").append(floorplans);

$ ->
  pricingOptions = JSON.parse($('#pricing-service-config:first').html())

  new pricingAndAvailability(pricingOptions)
