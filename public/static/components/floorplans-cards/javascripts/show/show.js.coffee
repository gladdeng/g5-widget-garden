class populateUnitData
  floorplanConfig = JSON.parse($('#floorplan-cards-config').html())
  url = floorplanConfig["floorplanDataFeed"]

  $.getJSON(url, (unitData) -> buildHTML(unitData))

  buildHTML = (unitData) ->
    unitsDiv = $('.floorplans-cards').first()
    unitsMarkup = ""
    for index, floorplan of unitData
      unitsMarkup += "<div class='floorplan-card'>
                        <div class='floorplan-card-title'>#{floorplan["title"]}</div>
                        
                        <a href='#{floorplan["image_url"]}' target='_blank' class='floorplan-view-link'><span>View</span></a>
                        <div class='unit-details'>
                          <div class='unit-beds'>#{bedroomMarkup floorplan["beds"]}</div>
                          <div class='unit-baths'><span>#{floorplan["baths"]}</span> Bathroom</div>
                          <div class='unit-size'>#{floorplan["size"]} Sq. Ft.</div>
                          <div class='unit-rate'>From #{floorplan["price"]}</div>
                        </div>
                        <a href='#' class='unit-cta-button'>Unit CTA</a>
                      </div>"

    unitsDiv.append(unitsMarkup)

  bedroomMarkup = (bedrooms) ->
    if bedrooms > 0
      "<span>#{bedrooms}</span> Bedroom"
    else
      "<span>S</span> Studio"

