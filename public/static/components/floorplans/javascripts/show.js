(function() {
  var appendFloorplans, pricingAndAvailability, setPricingHeight, setupFilters;

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
        url: pricingURL
      }).done(function(data) {
        appendFloorplans(data, floorplanContainer, loader);
        return setupFilters();
      });
    };

    return pricingAndAvailability;

  })();

  appendFloorplans = function(data, floorplanContainer, loader) {
    var $data, floorplanList, images, loadCounter;
    floorplanContainer.hide();
    $("[role=main]").append(loader);
    $data = $(data);
    floorplanList = $data.find(".e-content");
    floorplanContainer.append(floorplanList).fadeIn();
    $("#loading-floorplans").fadeOut().remove();
    loadCounter = 0;
    images = floorplanContainer.find('img');
    return $.each(images, function(i, item) {
      return $(item).load(function() {
        loadCounter++;
        console.log('image ' + i + 'loaded');
        if (loadCounter === images.length) {
          console.log('all images loaded');
          return setPricingHeight(floorplanContainer);
        }
      });
    });
  };

  setPricingHeight = function(floorplanContainer) {
    var floorplansHeight;
    floorplanContainer = $('.floorplans');
    floorplansHeight = floorplanContainer.outerHeight();
    return floorplanContainer.css('height', floorplansHeight);
  };

  setupFilters = function() {
    var floorplans;
    floorplans = $(".floorplan");
    $('.filters input[type=radio]').each(function() {
      var klass;
      klass = $(this).attr('id');
      if (!(floorplans.hasClass(klass) || klass.match(/^\w+-all/))) {
        return $(this).prop("disabled", true).next().addClass('disabled');
      }
    });
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
  };

  $(function() {
    var pricingOptions;
    pricingOptions = JSON.parse($('.floorplans .config:first').html());
    new pricingAndAvailability(pricingOptions);
    return $.getScript("http://g5-widget-garden.herokuapp.com/javascripts/libs/fancybox/jquery.fancybox.pack.js").done(function() {
      return $(".floorplans .floorplan-btn").fancybox();
    });
  });

}).call(this);
