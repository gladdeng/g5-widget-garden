(function() {
  var customizeUnitGrid, initializeUnitGrid, populateUnitData;

  populateUnitData = (function() {
    var bedroomMarkup, buildHTML;

    function populateUnitData(floorplanConfig) {
      var ctaText, dataFeed;
      dataFeed = floorplanConfig['floorplanDataFeed'];
      ctaText = floorplanConfig['ctaText'];
      $.getJSON(dataFeed, function(unitData) {
        return buildHTML(unitData, ctaText);
      }).then(function(response) {
        return new customizeUnitGrid(floorplanConfig);
      });
    }

    buildHTML = function(unitData, ctaText) {
      var floorplan, index, unitsDiv, unitsMarkup;
      unitsDiv = $('.floorplans-cards').first();
      unitsMarkup = "";
      for (index in unitData) {
        floorplan = unitData[index];
        unitsMarkup += "<div class='floorplan-card'>                        <div class='floorplan-card-title'>" + floorplan["title"] + "</div>                        <a href='" + floorplan["image_url"] + "' class='floorplan-view-link'>                          <div>View<span></span></div>                        </a>                        <div class='unit-details'>                          <div class='unit-beds'>" + (bedroomMarkup(floorplan["beds"])) + "</div>                          <div class='unit-baths'><span>" + floorplan["baths"] + "</span> Bathroom</div>                          <div class='unit-size'>" + floorplan["size"] + " Sq. Ft.</div>                          <div class='unit-rate'>From <span>$" + floorplan["price"] + "</span></div>                        </div>                        <a href='" + floorplan["price_url"] + "' class='unit-cta-button'>" + ctaText + "</a>                      </div>";
      }
      return unitsDiv.append(unitsMarkup);
    };

    bedroomMarkup = function(bedrooms) {
      if (bedrooms > 0) {
        return "<span>" + bedrooms + "</span> Bedroom";
      } else {
        return "<span>S</span> Studio";
      }
    };

    return populateUnitData;

  })();

  customizeUnitGrid = (function() {
    var setAccents1, setAccents2, setCtaColor, setHeadingColor;

    function customizeUnitGrid(colorConfigurations) {
      setHeadingColor(colorConfigurations['headingColor']);
      setCtaColor(colorConfigurations['ctaColor'], colorConfigurations['accentColor1']);
      setAccents1(colorConfigurations['accentColor1']);
      setAccents2(colorConfigurations['accentColor2']);
      $(".floorplan-view-link").fancybox();
    }

    setHeadingColor = function(color) {
      return $('.floorplan-card-title').css('background-color', color);
    };

    setCtaColor = function(color, hoverColor) {
      var ctaButtons;
      ctaButtons = $('.unit-cta-button');
      ctaButtons.css('background-color', color);
      return ctaButtons.hover(function() {
        return $(this).css('background-color', hoverColor);
      }, function() {
        return $(this).css('background-color', color);
      });
    };

    setAccents1 = function(color) {
      return $('.floorplan-view-link span').css('background-color', color);
    };

    setAccents2 = function(color) {
      return $('.unit-beds span, .unit-baths span, .floorplan-view-link div').css('background-color', color);
    };

    return customizeUnitGrid;

  })();

  initializeUnitGrid = (function() {
    var floorplanConfig;

    function initializeUnitGrid() {}

    floorplanConfig = JSON.parse($('#floorplan-cards-config').html());

    new populateUnitData(floorplanConfig);

    return initializeUnitGrid;

  })();

}).call(this);
