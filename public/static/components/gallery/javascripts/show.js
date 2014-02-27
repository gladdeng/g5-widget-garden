(function() {
  var getTallestImage, resetFlexslider, setupFlexslider;

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

  getTallestImage = function() {};

  setupFlexslider = function() {
    var fixed_height, galleryOptions, images, nav_height, slides, tallest_image, window_height, wrapper;
    wrapper = $('.slides');
    slides = wrapper.find('li').addClass('loading');
    images = wrapper.find('img');
    window_height = $(window).height();
    tallest_image = 0;
    fixed_height = 0;
    images.each(function() {
      var cur_height;
      cur_height = $(this).height();
      if (cur_height > tallest_image) {
        return tallest_image = cur_height;
      }
    });
    slides.removeClass('loading');
    galleryOptions = JSON.parse($(".gallery .config:first").html());
    $(".flexslider").flexslider({
      animation: galleryOptions['animation'],
      useCSS: true,
      touch: true,
      directionNav: true
    });
    nav_height = $('.flexslider .flex-control-nav').outerHeight();
    if (window_height <= tallest_image + nav_height) {
      fixed_height = window_height - nav_height;
    } else {
      fixed_height = tallest_image;
    }
    return images.css('max-height', fixed_height);
  };

  resetFlexslider = function() {
    var fixed_height, images, nav_height, slides, tallest_image, window_height, wrapper;
    wrapper = $('.slides');
    slides = wrapper.find('li').addClass('loading');
    images = wrapper.find('img').css('max-height', 'none');
    window_height = $(window).height();
    tallest_image = 0;
    fixed_height = 0;
    images.each(function() {
      var cur_height;
      cur_height = $(this).height();
      if (cur_height > tallest_image) {
        return tallest_image = cur_height;
      }
    });
    slides.removeClass('loading');
    nav_height = $('.flexslider .flex-control-nav').outerHeight();
    if (window_height <= tallest_image + nav_height) {
      fixed_height = window_height - nav_height;
    } else {
      fixed_height = tallest_image;
    }
    return images.css('max-height', fixed_height);
  };

  $(function() {
    setupFlexslider();
    return $(window).smartresize(function() {
      return resetFlexslider();
    });
  });

}).call(this);
