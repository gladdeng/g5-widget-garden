(function() {
  $(window).load(function() {
    var galleryOptions;
    galleryOptions = JSON.parse($("#gallery-config:first").html());
    return $(".flexslider").flexslider(galleryOptions);
  });

}).call(this);
