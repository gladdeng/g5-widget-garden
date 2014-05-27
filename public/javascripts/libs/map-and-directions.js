function app(jQuery) {

  // If <= IE 9
  if (window.XDomainRequest) {
    loadIEScript();
  }

  loadScript();

  function loadScript() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initialize";

    $("body").append(script);
  };

  function loadIEScript() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://g5-widget-garden.herokuapp.com/javascripts/libs/jquery.xdomainrequest.min.js";

    $("body").append(script);
  }

};

function initialize() {
  if ($(".map").length) {
    window.getMapCoords();
  }
  if ($(".directions").length) {
    window.getDirectionsCoords();
  }
  if ($(".human-directions").length) {
    window.getHumanDirectionsCoords();
  }
}

$(document).ready(app);
