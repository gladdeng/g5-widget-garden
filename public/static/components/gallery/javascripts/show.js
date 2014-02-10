(function() {
  var setupFlexslider;

  setupFlexslider = function() {
    var bottom_space, image_height, images, slides, tallest_image, window_height, wrapper, wrapper_height;
    wrapper = $('.flexslider-container');
    slides = wrapper.find('.flexslider li').addClass('loading');
    images = slides.find('img');
    window_height = $(window).height();
    tallest_image = 0;
    wrapper_height = 0;
    image_height = 0;
    bottom_space = 33 + 10;
    slides.each(function() {
      var cur_height;
      cur_height = $(this).find('img').height();
      if (cur_height > tallest_image) {
        return tallest_image = cur_height;
      }
    });
    slides.removeClass('loading');
    if (window_height < tallest_image + bottom_space) {
      wrapper_height = window_height;
      image_height = window_height - bottom_space;
    } else {
      wrapper_height = tallest_image + bottom_space;
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
