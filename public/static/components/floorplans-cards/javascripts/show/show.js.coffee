class populateUnitData
  # eventually need to pull this url from the widget variables
  url = 'http://localhost:3004/locations/abc-123/floor_plans.json'

  $.getJSON(url, (unitData) -> buildHTML(unitData))

  buildHTML = (unitData) ->
    unitsDiv = $('.floorplans-cards').first()
    unitsMarkup = ""
    for index, floorplan of unitData
      unitsMarkup += "<div class='floorplan-card'>
                        <div class='floorplan-card-title'>#{floorplan["title"]}</div>
                        
                        <a href='#{floorplan["image_url"]}' target='_blank' class='floorplan-view-link'>View</a>
                        <div class='unit-details'>
                          <div class='unit-beds'>#{bedroomMarkup floorplan["beds"]}</div>
                          <div class='unit-baths'><span>#{floorplan["baths"]}</span> Bathroom</div>
                          <div class='unit-size'>#{floorplan["size"]} Sq. Ft.</div>
                          <div class='unit-rate'>From #{floorplan["price"]}</div>
                        </div>
                      </div>"

    unitsDiv.append(unitsMarkup)

  bedroomMarkup = (bedrooms) ->
    if bedrooms > 0
      "<span>#{bedrooms}</span> Bedroom"
    else
      "Studio"

 