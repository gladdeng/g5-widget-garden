(function() {
  var pricingAndAvailability;

  pricingAndAvailability = (function() {
    function pricingAndAvailability(pricingOptions) {
      var client_urn, location_urn;
      client_urn = pricingOptions["clientUrn"].replace(/^g5-c-/, "g5-cpas-");
      location_urn = pricingOptions["locationUrn"];
      if (client_urn && location_urn) {
        this.getPricing(client_urn, location_urn);
      }
    }

    pricingAndAvailability.prototype.getPricing = function(client_urn, location_urn) {
      return $.get("http://" + client_urn + ".herokuapp.com/locations/" + location_urn, function(data) {
        var $data, floorplans;
        $data = $(data);
        floorplans = $data.find('.e-content');
        return $("#floorplans").append(floorplans);
      });
    };

    return pricingAndAvailability;

  })();

  $(function() {
    var pricingOptions;
    pricingOptions = JSON.parse($('#pricing-service-config:first').html());
    return new pricingAndAvailability(pricingOptions);
  });

}).call(this);
