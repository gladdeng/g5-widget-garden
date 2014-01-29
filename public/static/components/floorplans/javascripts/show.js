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
        $(".floorplans").hide();
        $('[role=main]').append('<div id="loading-floorplans">Loading&hellip;</div>');
        $data = $(data);
        floorplans = $data.find('.e-content');
        $(".floorplans").append(floorplans).fadeIn();
        $('#loading-floorplans').fadeOut().remove();
        return $(".filters input").on("change", function(e) {
          var bathFilter, bathSelector, bedFilter, bedSelector;
          bedFilter = $('#beds-filter input:checked').val();
          bathFilter = $('#baths-filter input:checked').val();
          bedSelector = '';
          bathSelector = '';
          if (bedFilter === 'beds-all' && bathFilter === 'baths-all') {
            return $('.floorplan').fadeIn();
          } else {
            if (bedFilter !== 'beds-all') {
              bedSelector = '.' + bedFilter;
            }
            if (bathFilter !== 'baths-all') {
              bathSelector = '.' + bathFilter;
            }
            $('.floorplan').fadeOut();
            return $(bedSelector + bathSelector).fadeIn('fast');
          }
        });
      });
    };

    return pricingAndAvailability;

  })();

  $(function() {
    var pricingOptions;
    pricingOptions = JSON.parse($('.floorplans .config:first').html());
    new pricingAndAvailability(pricingOptions);
    return $(".floorplans .floorplan-btn").fancybox();
  });

}).call(this);
