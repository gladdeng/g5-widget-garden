(function() {
  var pricingAndAvailability;

  pricingAndAvailability = (function() {
    function pricingAndAvailability(pricingOptions) {
      var cpas_urn, heroku_app_name_max_length, location_urn;
      heroku_app_name_max_length = 30;
      cpas_urn = pricingOptions["clientUrn"].replace(/-c-/, "-cpas-");
      cpas_urn = cpas_urn.substring(0, heroku_app_name_max_length);
      location_urn = pricingOptions["locationUrn"];
      if (cpas_urn && location_urn) {
        this.getPricing(cpas_urn, location_urn);
      }
    }

    pricingAndAvailability.prototype.getPricing = function(cpas_urn, location_urn) {
      var floorplanContainer, loader, pricingURL;
      pricingURL = "http://" + cpas_urn + ".herokuapp.com/locations/" + location_urn;
      floorplanContainer = $('.floorplans');
      loader = '<div id="loading-floorplans"><div class="loader">Loading&hellip;</div>Loading Pricing &amp; Availibility Information&hellip;</div>';
      return $.ajax({
        type: "GET",
        url: pricingURL,
        success: function(data) {
          var $data, floorplanList, floorplans;
          floorplanContainer.hide();
          $("[role=main]").append(loader);
          $data = $(data);
          floorplanList = $data.find(".e-content");
          floorplanContainer.append(floorplanList).fadeIn();
          $("#loading-floorplans").fadeOut().remove();
          floorplans = $(".floorplan");
          return $(".filters input").on("change", function(e) {
            var bathFilter, bathSelector, bedFilter, bedSelector;
            bedFilter = $("#beds-filter input:checked").val();
            bathFilter = $("#baths-filter input:checked").val();
            bedSelector = "";
            bathSelector = "";
            if (bedFilter === "beds-all" && bathFilter === "baths-all") {
              return floorplans.fadeIn();
            } else {
              if (bedFilter !== "beds-all") {
                bedSelector = "." + bedFilter;
              }
              if (bathFilter !== "baths-all") {
                bathSelector = "." + bathFilter;
              }
              floorplans.fadeOut();
              return $(bedSelector + bathSelector).fadeIn("fast");
            }
          });
        }
      });
    };

    return pricingAndAvailability;

  })();

  $(window).load(function() {
    var pricingOptions;
    pricingOptions = JSON.parse($('.floorplans .config:first').html());
    new pricingAndAvailability(pricingOptions);
    return $(".floorplans .floorplan-btn").fancybox();
  });

}).call(this);
