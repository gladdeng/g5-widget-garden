(function() {
  $(window).load(function() {
    var flex_height, images, max_height, slider, window_height;
    window_height = $(window).height();
    slider = $('.flexslider');
    images = slider.find('li img');
    max_height = 0;
    flex_height = 0;
    images.each(function() {
      var cur_height;
      cur_height = $(this).height();
      if (cur_height > max_height) {
        return max_height = cur_height;
      }
    });
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
