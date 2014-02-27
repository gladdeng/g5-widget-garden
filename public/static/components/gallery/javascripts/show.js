(function() {
  var gallery, getTallestImage, initializeFlexSlider, resetFlexslider, setImageHeight, setupFlexslider;

  gallery = {
    wrapper: $(".slides"),
    slides: $(".slides li"),
    images: $(".slides img")
  };

  (function($, sr) {
    var debounce;
    debounce = void 0;
    debounce = function(func, threshold, execAsap) {
      var debounced, timeout;
      debounced = void 0;
      timeout = void 0;
      timeout = void 0;
      return debounced = function() {
        var delayed, obj;
        delayed = void 0;
        obj = void 0;
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

  getTallestImage = function() {
    var tallest_image;
    gallery.slides.addClass("loading");
    gallery.images.css("max-height", "none");
    tallest_image = 0;
    gallery.images.each(function() {
      var cur_height;
      cur_height = void 0;
      cur_height = $(this).height();
      if (cur_height > tallest_image) {
        tallest_image = cur_height;
      }
    });
    gallery.slides.removeClass("loading");
    return tallest_image;
  };

  initializeFlexSlider = function() {
    var galleryOptions;
    galleryOptions = JSON.parse($(".gallery .config:first").html());
    return $(".flexslider").flexslider({
      animation: galleryOptions["animation"],
      useCSS: true,
      touch: true,
      directionNav: true
    });
  };

  setImageHeight = function(tallest_image) {
    var fixed_height, nav_height, window_height;
    window_height = $(window).height();
    nav_height = $(".flexslider .flex-control-nav").outerHeight();
    fixed_height = void 0;
    if (window_height <= tallest_image + nav_height) {
      fixed_height = window_height - nav_height - 10;
    } else {
      fixed_height = tallest_image - 10;
    }
    return gallery.images.css("max-height", fixed_height);
  };

  setupFlexslider = function() {
    var tallest_image;
    tallest_image = getTallestImage();
    initializeFlexSlider();
    return setImageHeight(tallest_image);
  };

  resetFlexslider = function() {
    var tallest_image;
    tallest_image = getTallestImage();
    return setImageHeight(tallest_image);
  };

  $(function() {
    setupFlexslider();
    return $(window).smartresize(function() {
      return resetFlexslider();
    });
  });

}).call(this);
