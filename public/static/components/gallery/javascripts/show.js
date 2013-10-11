// http://www.woothemes.com/flexslider/
$(window).load(function() {
  var galleryOptions;
  galleryOptions = JSON.parse($('#gallery-config:first').html());
  $('.flexslider').flexslider(galleryOptions);
});
