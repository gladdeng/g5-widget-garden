(function() {
  var gallery, getTallestImage, initializeFlexSlider, resetFlexslider, resetMiniFlexslider, setImageHeight, setMiniNavHeight, setupFlexslider;

  gallery = {
    flexContainer: $('.flexslider'),
    wrapper: $('.slides'),
    slides: $('.slides li'),
    images: $('.slides img')
  };

  initializeFlexSlider = function(galleryOptions) {
    var captionHeight, navHeight, showThumbs;
    showThumbs = (galleryOptions['show_thumbnails'] === "yes" ? "thumbnails" : true);
    gallery.flexContainer.flexslider({
      animation: galleryOptions['animation'],
      useCSS: true,
      touch: true,
      directionNav: true,
      controlNav: showThumbs
    });
    if (galleryOptions['mini_gallery'] === 'no') {
      navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight();
      captionHeight = getTallestCaption();
      gallery.flexContainer.find('.flex-control-nav').css('bottom', -navHeight);
      return gallery.flexContainer.css('margin-bottom', -navHeight);
    }
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

  setImageHeight = function(tallestImage) {
    var fixedHeight, navHeight, padding, windowHeight;
    windowHeight = $(window).height();
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true);
    fixedHeight = null;
    padding = 10;
    if (windowHeight <= tallestImage + navHeight) {
      fixedHeight = windowHeight - navHeight - padding;
    } else {
      fixedHeight = tallestImage - padding;
    }
    gallery.images.css('max-height', fixedHeight);
    gallery.slides.css('height', fixedHeight);
    gallery.flexContainer.find('.flex-control-nav').css('bottom', -navHeight);
    return gallery.flexContainer.css('margin-bottom', navHeight);
  };

  setMiniNavHeight = function(tallestImage) {
    return $('.flex-direction-nav a').height(tallestImage);
  };

  setupFlexslider = function(galleryOptions) {
    var tallestImage;
    tallestImage = getTallestImage();
    initializeFlexSlider(galleryOptions);
    if (galleryOptions['mini_gallery'] === 'yes') {
      return setMiniNavHeight(tallestImage);
    } else {
      return setImageHeight(tallestImage);
    }
  };

  resetFlexslider = function() {
    var tallestImage;
    tallestImage = getTallestImage();
    return setImageHeight(tallestImage);
  };

  resetMiniFlexslider = function() {
    var tallestImage;
    tallestImage = getTallestImage();
    return setMiniNavHeight(tallestImage);
  };

  $(function() {
    var galleryOptions;
    galleryOptions = JSON.parse($('.gallery .config:first').html());
    setupFlexslider(galleryOptions);
    if (galleryOptions['mini_gallery'] === 'yes') {
      return $(window).smartresize(function() {
        return resetMiniFlexslider();
      });
    } else {
      return $(window).smartresize(function() {
        return resetFlexslider();
      });
    }
  });

}).call(this);
