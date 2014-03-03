(function() {
  var gallery, getTallestImage, initializeFlexSlider, resetFlexslider, setImageHeight, setupFlexslider;

  gallery = {
    flexContainer: $('.flexslider'),
    wrapper: $('.slides'),
    slides: $('.slides li'),
    images: $('.slides img')
  };

  getTallestImage = function() {
    var tallestImage;
    gallery.slides.addClass('loading');
    gallery.images.css('max-height', 'none');
    tallestImage = 0;
    gallery.images.each(function() {
      var curHeight;
      curHeight = null;
      curHeight = $(this).height();
      if (curHeight > tallestImage) {
        tallestImage = curHeight;
      }
    });
    gallery.slides.removeClass('loading');
    return tallestImage;
  };

  initializeFlexSlider = function() {
    var galleryOptions, navHeight;
    galleryOptions = JSON.parse($('.gallery .config:first').html());
    gallery.flexContainer.flexslider({
      animation: galleryOptions['animation'],
      useCSS: true,
      touch: true,
      directionNav: true,
      after: function(slider) {
        var currHeight;
        currHeight = gallery.slides.eq(slider.currentSlide).outerHeight(true);
        gallery.flexContainer.height(currHeight);
        return gallery.wrapper.height(currHeight);
      }
    });
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight();
    gallery.flexContainer.css('margin-bottom', navHeight);
    return gallery.flexContainer.find('.flex-control-nav').css('bottom', -navHeight);
  };

  setImageHeight = function(tallestImage) {
    var fixedHeight, navHeight, padding, windowHeight;
    windowHeight = $(window).height();
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight();
    fixedHeight = null;
    padding = 10;
    if (windowHeight <= tallestImage + navHeight) {
      fixedHeight = windowHeight - navHeight - padding;
    } else {
      fixedHeight = tallestImage - padding;
    }
    return gallery.images.css('max-height', fixedHeight);
  };

  setupFlexslider = function() {
    var tallestImage;
    tallestImage = getTallestImage();
    initializeFlexSlider();
    return setImageHeight(tallestImage);
  };

  resetFlexslider = function() {
    var tallestImage;
    tallestImage = getTallestImage();
    setImageHeight(tallestImage);
    return gallery.wrapper.height('auto');
  };

  $(function() {
    setupFlexslider();
    return $(window).smartresize(function() {
      return resetFlexslider();
    });
  });

}).call(this);
