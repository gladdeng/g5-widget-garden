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
    floorplanContainer = $('.floorplans')
    loader = '<div id="loading-floorplans"><div class="loader">Loading&hellip;</div>Loading Pricing &amp; Availibility Information&hellip;</div>'

    $.ajax
      type: "GET"
      url: pricingURL
      success: (data) ->
        floorplanContainer.hide()
        $("[role=main]").append loader
        $data = $(data)
        floorplanList = $data.find(".e-content")
        floorplanContainer.append(floorplanList).fadeIn()
        $("#loading-floorplans").fadeOut().remove()
        floorplans = $(".floorplan")
        $(".filters input").on "change", (e) ->
          bedFilter = $("#beds-filter input:checked").val()
          bathFilter = $("#baths-filter input:checked").val()
          bedSelector = ""
          bathSelector = ""
          if bedFilter is "beds-all" and bathFilter is "baths-all"
            floorplans.fadeIn()
          else
            bedSelector = "." + bedFilter  if bedFilter isnt "beds-all"
            bathSelector = "." + bathFilter  if bathFilter isnt "baths-all"
            floorplans.fadeOut()
            $(bedSelector + bathSelector).fadeIn "fast"




$(window).load ->
  pricingOptions = JSON.parse($('.floorplans .config:first').html())
  new pricingAndAvailability(pricingOptions)
  $(".floorplans .floorplan-btn").fancybox()

