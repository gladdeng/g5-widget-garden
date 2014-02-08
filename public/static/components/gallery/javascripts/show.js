(function() {
  var setupFlexslider;

  setupFlexslider = function() {
    var image_height, images, nav_height, slides, tallest_image, window_height, wrapper, wrapper_height;
    wrapper = $('.flexslider-container');
    slides = wrapper.find('.flexslider li').addClass('loading');
    images = slides.find('img');
    window_height = $(window).height();
    tallest_image = 0;
    wrapper_height = 0;
    image_height = 0;
    nav_height = 33;
    slides.each(function() {
      var cur_height;
      cur_height = $(this).find('img').height();
      if (cur_height > tallest_image) {
        return tallest_image = cur_height;
      }
    });
    slides.removeClass('loading');
    if (window_height < tallest_image + nav_height) {
      wrapper_height = window_height;
      image_height = window_height - nav_height;
    } else {
      wrapper_height = tallest_image + nav_height;
      image_height = tallest_image;
    }
    wrapper.css('height', wrapper_height);
    return images.css('max-height', image_height);
  };

  $(function() {
    setupFlexslider();
    $(window).resize(function() {
      return setupFlexslider();
    });
    return $('.flexslider').flexslider({
      animation: "fade",
      useCSS: true,
      touch: true,
      directionNav: true
    });
  });

}).call(this);
