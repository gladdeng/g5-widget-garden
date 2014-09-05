(function() {
  var gallery, getLargestImage, initializeFlexSlider, resetFlexslider, resetMiniFlexslider, setImageHeight, setMiniNavHeight, setupFlexslider;

  gallery = {
    flexContainer: $('.flexslider'),
    wrapper: $('.slides'),
    slides: $('.slides li'),
    images: $('.slides img')
  };

  initializeFlexSlider = function(galleryOptions) {
    var navHeight, showThumbs;
    showThumbs = (galleryOptions['show_thumbnails'] === "yes" ? "thumbnails" : true);
    gallery.flexContainer.flexslider({
      animation: galleryOptions['animation'],
      useCSS: true,
      touch: true,
      directionNav: true,
      controlNav: showThumbs
    });
    if (galleryOptions['mini_gallery'] === 'no') {
      navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true);
      gallery.flexContainer.find('.flex-control-nav').css('bottom', -navHeight);
      return gallery.flexContainer.css('margin-bottom', -navHeight);
    }
  };

  getLargestImage = function() {
    var imageHeight, imageWidth, size;
    gallery.slides.addClass('loading');
    gallery.images.css('max-height', 'none');
    imageHeight = 0;
    imageWidth = 0;
    size = [];
    gallery.images.each(function() {
      var curHeight;
      curHeight = null;
      curHeight = $(this).height();
      if (curHeight > imageHeight) {
        imageHeight = curHeight;
        return imageWidth = $(this).width();
      }
    });
    gallery.slides.removeClass('loading');
    size['height'] = imageHeight;
    size['width'] = imageWidth;
    return size;
  };

  setImageHeight = function(imageHeight) {
    var fixedHeight, navHeight, padding, windowHeight;
    windowHeight = $(window).height();
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true);
    fixedHeight = null;
    padding = 10;
    if (windowHeight <= imageHeight + navHeight) {
      fixedHeight = windowHeight - navHeight - padding;
    } else {
      fixedHeight = imageHeight - padding;
    }
    gallery.images.css('max-height', fixedHeight);
    gallery.slides.css('height', fixedHeight);
    gallery.flexContainer.find('.flex-control-nav').css('bottom', -navHeight);
    return gallery.flexContainer.css('margin-bottom', navHeight);
  };

  setMiniNavHeight = function(imageHeight) {
    return $('.flex-direction-nav a').height(imageHeight);
  };

  setupFlexslider = function(galleryOptions) {
    var imageHeight, imageWidth, size;
    size = getLargestImage();
    imageHeight = size['height'];
    imageWidth = size['width'];
    initializeFlexSlider(galleryOptions);
    if (galleryOptions['mini_gallery'] === 'yes') {
      return setMiniNavHeight(imageHeight);
    } else {
      return setImageHeight(imageHeight);
    }
  };

  resetFlexslider = function() {
    var imageHeight, size;
    size = getLargestImage();
    imageHeight = size['height'];
    return setImageHeight(imageHeight);
  };

  resetMiniFlexslider = function() {
    var imageHeight, size;
    size = getLargestImage();
    imageHeight = size['height'];
    return setMiniNavHeight(imageHeight);
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
