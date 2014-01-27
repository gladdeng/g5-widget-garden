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
      var pricingURL;
      pricingURL = "http://" + cpas_urn + ".herokuapp.com/locations/" + location_urn;
      return $.get(pricingURL, function(data) {
        var $data, floorplans;
        $data = $(data);
        floorplans = $data.find('.e-content');
        return $(".floorplans").append(floorplans);
      });
    };

    return pricingAndAvailability;

  })();

  $(function() {
    var pricingOptions;
    pricingOptions = JSON.parse($('.floorplans .config:first').html());
    new pricingAndAvailability(pricingOptions);
    $(".floorplans .floorplan-btn").fancybox();
    return $(".filter-btn").live("click", function(e) {
      var filterName, filterValue, floorplans;
      e.stopPropagation();
      floorplans = $("#sortable li");
      filterName = $(this).attr("for").split("-")[0];
      filterValue = $(this).text();
      return floorplans.each(function(i) {
        var actual, filterClass;
        filterClass = "." + filterName + "-val";
        actual = $(this).find(filterClass).text();
        if (filterValue === "All") {
          return $(this).show();
        } else if (actual === filterValue) {
          return $(this).show();
        } else {
          return $(this).hide();
        }
      });
    });
  });

}).call(this);
