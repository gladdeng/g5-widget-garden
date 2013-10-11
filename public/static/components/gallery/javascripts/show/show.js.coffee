# http://www.woothemes.com/flexslider/
$(window).load ->
  galleryOptions = JSON.parse($("#gallery-config:first").html())
  $(".flexslider").flexslider galleryOptions