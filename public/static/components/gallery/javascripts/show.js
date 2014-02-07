(function() {
  $(function() {
    var flex_height, images, max_height, slider, slides, window_height;
    slider = $('.flexslider');
    slides = slider.find('li').addClass('loading');
    images = slides.find('img');
    window_height = $(window).height();
    max_height = 0;
    flex_height = 0;
    slides.each(function() {
      var cur_height;
      cur_height = $(this).find('img').height();
      if (cur_height > max_height) {
        return max_height = cur_height;
      }
    });
    slides.removeClass('loading');
    if (window_height < max_height) {
      flex_height = window_height - 20;
    } else {
      flex_height = max_height - 20;
    }
    slider.css('height', flex_height);
    images.css('max-height', flex_height);
    return slider.flexslider({
      "animation": "fade",
      "useCSS": true,
      "touch": true,
      "directionNav": true
    });
  });

}).call(this);
