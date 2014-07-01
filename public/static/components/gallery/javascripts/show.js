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
        return tallestImage = curHeight;
      }
    });
    gallery.slides.removeClass('loading');
    return tallestImage;
  };

  initializeFlexSlider = function() {
    var galleryOptions, navHeight, showThumbs;
    galleryOptions = JSON.parse($('.gallery .config:first').html());
    if (galleryOptions['show_thumbnails'] === 'true') {
      showThumbs = "thumbnails";
    } else {
      showThumbs = true;
    }
    console.log('setting: ' + galleryOptions['show_thumbnails'] + '\nVar: ' + showThumbs);
    gallery.flexContainer.flexslider({
      animation: galleryOptions['animation'],
      useCSS: true,
      touch: true,
      directionNav: true,
      controlNav: showThumbs
    });
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight();
    return gallery.flexContainer.css('padding-bottom', navHeight);
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
    gallery.images.css('max-height', fixedHeight);
    gallery.slides.css('height', fixedHeight);
    return gallery.flexContainer.css('padding-bottom', navHeight);
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
    return setImageHeight(tallestImage);
  };

  $(function() {
    setupFlexslider();
    return $(window).smartresize(function() {
      return resetFlexslider();
    });
  });

}).call(this);
