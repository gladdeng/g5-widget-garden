(function() {
  var populateUnitData;

  populateUnitData = (function() {
    var buildHTML, url;

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
        unitsMarkup += "<div class='floorplan-card'>                        <div>" + floorplan["title"] + "</div>                        <div>                          <a href='" + floorplan["image_url"] + "' target='_blank'>View</a>                        </div>                        <div>" + floorplan["beds"] + " Bedroom</div>                        <div>" + floorplan["baths"] + " Bathroom</div>                        <div>" + floorplan["size"] + " Sq. Ft.</div>                        <div>From " + floorplan["price"] + "</div>                      </div>";
      }
      return unitsDiv.html(unitsMarkup);
    };

    return populateUnitData;

  })();

}).call(this);
