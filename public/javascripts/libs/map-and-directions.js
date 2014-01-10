function app(jQuery) {
  loadScript();

  function loadScript() {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "http://maps.googleapis.com/maps/api/js?sensor=false&callback=initialize";

    document.body.appendChild(script);
  };
};

function initialize() {
  if ($("#map .canvas").length) {
    window.getMapCoords();
  }
  if ($("#directions .canvas").length) {
    window.getDirectionsCoords();
  }
}

$(document).ready(app);
