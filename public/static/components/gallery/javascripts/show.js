(function() {
  var resetFlexslider, setupFlexslider;

  (function($, sr) {
    var debounce;
    debounce = function(func, threshold, execAsap) {
      var debounced, timeout;
      timeout = void 0;
      return debounced = function() {
        var delayed, obj;
        delayed = function() {
          if (!execAsap) {
            func.apply(obj);
          }
          timeout = null;
        };
        obj = this;
        if (timeout) {
          clearTimeout(timeout);
        } else {
          if (execAsap) {
            func.apply(obj);
          }
        }
        timeout = setTimeout(delayed, threshold || 100);
      };
    };
    jQuery.fn[sr] = function(fn) {
      if (fn) {
        return this.bind("resize", debounce(fn));
      } else {
        return this.trigger(sr);
      }
    };
  })(jQuery, "smartresize");

  setupFlexslider = function() {
    var bottom_space, image_height, images, slides, tallest_image, window_height, wrapper, wrapper_height;
    wrapper = $('.flexslider-container');
    slides = wrapper.find('.flexslider li').addClass('loading');
    images = slides.find('img');
    window_height = $(window).height();
    tallest_image = 0;
    wrapper_height = 0;
    image_height = 0;
    bottom_space = 58 + 10;
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

  resetFlexslider = function() {
    var images, wrapper;
    wrapper = $('.flexslider-container');
    images = wrapper.find('.slides img');
    wrapper.css('height', 'auto');
    images.css('max-height', 'none');
    return setupFlexslider();
  };

  $(function() {
    var galleryOptions;
    setupFlexslider();
    galleryOptions = JSON.parse($(".gallery .config:first").html());
    $(".flexslider").flexslider({
      animation: galleryOptions['animation'],
      useCSS: true,
      touch: true,
      directionNav: true
    });
    return $(window).smartresize(function() {
      return resetFlexslider();
    });
  });

}).call(this);
