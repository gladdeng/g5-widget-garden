class populateUnitData
  constructor: (floorplanConfig) -> 
    dataFeed = floorplanConfig['floorplanDataFeed']
    ctaText = floorplanConfig['ctaText']
    $.getJSON(dataFeed, (unitData) -> buildHTML(unitData, ctaText)).then (response) ->
      new customizeUnitGrid(floorplanConfig)

  buildHTML = (unitData, ctaText) ->
    unitsDiv = $('.floorplans-cards').first()
    unitsMarkup = ""
    for index, floorplan of unitData
      unitsMarkup += "<div class='floorplan-card'>
                        <div class='floorplan-card-title'>#{floorplan["title"]}</div>
                        <a href='#{floorplan["image_url"]}' class='floorplan-view-link'>
                          <div>View<span></span></div>
                        </a>
                        <div class='unit-details'>
                          <div class='unit-beds'>#{bedroomMarkup floorplan["beds"]}</div>
                          <div class='unit-baths'><span>#{floorplan["baths"]}</span> Bathroom</div>
                          <div class='unit-size'>#{floorplan["size"]} Sq. Ft.</div>
                          <div class='unit-rate'>From <span>$#{floorplan["price"]}</span></div>
                        </div>
                        <a href='#{floorplan["price_url"]}' class='unit-cta-button'>#{ctaText}</a>
                      </div>"

    unitsDiv.append(unitsMarkup)

  bedroomMarkup = (bedrooms) ->
    if bedrooms > 0
      "<span>#{bedrooms}</span> Bedroom"
    else
      "<span>S</span> Studio"

class customizeUnitGrid
  constructor: (colorConfigurations) ->
    setHeadingColor colorConfigurations['headingColor']
    setCtaColor colorConfigurations['ctaColor'], colorConfigurations['accentColor1']
    setAccents1 colorConfigurations['accentColor1']
    setAccents2 colorConfigurations['accentColor2']
    $(".floorplan-view-link").fancybox()

  setHeadingColor = (color) ->
    $('.floorplan-card-title').css('background-color', color)

  setCtaColor = (color, hoverColor) ->
    ctaButtons = $('.unit-cta-button')
    ctaButtons.css('background-color', color)
    ctaButtons.hover(
      -> $(this).css('background-color', hoverColor),
      -> $(this).css('background-color', color)
    )

  setAccents1 = (color) ->
    $('.floorplan-view-link span').css('background-color', color)

  setAccents2 = (color) ->
    $('.unit-beds span, .unit-baths span, .floorplan-view-link div').css('background-color', color)

    
class initializeUnitGrid
  floorplanConfig = JSON.parse($('#floorplan-cards-config').html())
  new populateUnitData(floorplanConfig)
  


  
