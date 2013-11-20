class pricingAndAvailability
  constructor: (pricingOptions) ->

    client_urn = pricingOptions["clientUrn"].replace(/^g5-c-/, "g5-cpas-")
    location_urn = pricingOptions["locationUrn"]

    if client_urn && location_urn
      @getPricing(client_urn, location_urn)

  getPricing: (client_urn, location_urn) ->
    $.get "http://localhost:5000/locations/g5-cl-6cx7rin-hollywood", (data) ->
      $data = $(data)
      floorplans = $data.find('.e-content')
      $("#floorplans").append(floorplans);

$ ->
  pricingOptions = JSON.parse($('#pricing-service-config:first').html())

  new pricingAndAvailability(pricingOptions)
