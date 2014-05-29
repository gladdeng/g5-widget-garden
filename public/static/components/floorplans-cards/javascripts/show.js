(function() {
  var populateUnitData;

  populateUnitData = (function() {
    var bedroomMarkup, buildHTML, url;

    function populateUnitData() {}

    url = 'http://localhost:3004/locations/abc-123/floor_plans.json';

    $.getJSON(url, function(unitData) {
      return buildHTML(unitData);
    });

    buildHTML = function(unitData) {
      var floorplan, index, unitsDiv, unitsMarkup;
      unitsDiv = $('.floorplans-cards').first();
      unitsMarkup = "";
      for (index in unitData) {
        floorplan = unitData[index];
        unitsMarkup += "<div class='floorplan-card'>                        <div class='floorplan-card-title'>" + floorplan["title"] + "</div>                                                <a href='" + floorplan["image_url"] + "' target='_blank' class='floorplan-view-link'>View</a>                        <div class='unit-details'>                          <div class='unit-beds'>" + (bedroomMarkup(floorplan["beds"])) + "</div>                          <div class='unit-baths'><span>" + floorplan["baths"] + "</span> Bathroom</div>                          <div class='unit-size'>" + floorplan["size"] + " Sq. Ft.</div>                          <div class='unit-rate'>From " + floorplan["price"] + "</div>                        </div>                      </div>";
      }
      return unitsDiv.append(unitsMarkup);
    };

    bedroomMarkup = function(bedrooms) {
      if (bedrooms > 0) {
        return "<span>" + bedrooms + "</span> Bedroom";
      } else {
        return "Studio";
      }
    };

    return populateUnitData;

  })();

}).call(this);
