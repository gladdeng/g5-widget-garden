class populateUnitData
  # eventually need to pull this url from the widget variables
  url = 'http://localhost:3004/locations/abc-123/floor_plans.json'

  $.getJSON(url, (unitData) -> buildHTML(unitData))

  buildHTML = (unitData) ->
    unitsDiv = $('.floorplans-cards').first()
    unitsMarkup = ""
    for index, floorplan of unitData
      unitsMarkup += "<div class='floorplan-card'>
                        <div>#{floorplan["title"]}</div>
                        <div>
                          <a href='#{floorplan["image_url"]}' target='_blank'>View</a>
                        </div>
                        <div>#{floorplan["beds"]} Bedroom</div>
                        <div>#{floorplan["baths"]} Bathroom</div>
                        <div>#{floorplan["size"]} Sq. Ft.</div>
                        <div>From #{floorplan["price"]}</div>
                      </div>"

    unitsDiv.html(unitsMarkup)

 