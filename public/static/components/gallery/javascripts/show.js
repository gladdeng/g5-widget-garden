(function() {
  var getLargestImage, initializeFlexSlider, resetFlexslider, resetMiniFlexslider, setImageHeight, setMiniNavHeight, setupFlexslider;

  initializeFlexSlider = function(galleryOptions, imageWidth, gallery) {
    var navHeight, showThumbs;
    showThumbs = (galleryOptions['show_thumbnails'] === "yes" ? "thumbnails" : true);
    if (galleryOptions['carousel'] === 'yes') {
      gallery.find('.gallery-carousel').flexslider({
        animation: 'slide',
        animationLoop: false,
        itemWidth: imageWidth,
        itemMargin: 15
      });
    } else {
      gallery.find('.gallery-slideshow').flexslider({
        animation: 'fade',
        useCSS: true,
        touch: true,
        directionNav: true,
        controlNav: showThumbs
      });
    }
    if (galleryOptions['mini_gallery'] === 'no') {
      navHeight = gallery.find('.flex-control-nav').outerHeight(true);
      gallery.find('.flex-control-nav').css('bottom', -navHeight);
      return gallery.find('.flexslider').css('margin-bottom', -navHeight);
    }
  };

  getLargestImage = function(gallery) {
    var imageHeight, imageWidth, images, size, slides;
    slides = gallery.find('.slides li');
    images = gallery.find('.slides img');
    slides.addClass('loading');
    images.css('max-height', 'none');
    imageHeight = 0;
    imageWidth = 0;
    size = [];
    images.each(function() {
      var curHeight;
      curHeight = null;
      curHeight = $(this).height();
      if (curHeight > imageHeight) {
        imageHeight = curHeight;
        return imageWidth = $(this).width();
      }
    });
    slides.removeClass('loading');
    size['height'] = imageHeight;
    size['width'] = imageWidth;
    return size;
  };

  setImageHeight = function(imageHeight, gallery) {
    var fixedHeight, navHeight, padding, windowHeight;
    windowHeight = $(window).height();
    navHeight = gallery.find('.flex-control-nav').outerHeight(true);
    fixedHeight = null;
    padding = 10;
    if (windowHeight <= imageHeight + navHeight) {
      fixedHeight = windowHeight - navHeight - padding;
      if (fixedHeight < 320) {
        fixedHeight = imageHeight - padding;
      }
    } else {
      fixedHeight = imageHeight - padding;
    }
    gallery.find('.slides img').css('max-height', fixedHeight);
    gallery.find('.slides li').css('height', fixedHeight);
    gallery.find('.flex-control-nav').css('bottom', -navHeight);
    return gallery.find('.flexslider').css('margin-bottom', navHeight);
  };

  setMiniNavHeight = function(imageHeight, gallery) {
    return gallery.find('.flex-direction-nav a').height(imageHeight);
  };

  setupFlexslider = function(galleryOptions, gallery) {
    var imageHeight, imageWidth, size;
    size = getLargestImage(gallery);
    imageHeight = size['height'];
    imageWidth = size['width'];
    initializeFlexSlider(galleryOptions, imageWidth, gallery);
    if (galleryOptions['mini_gallery'] === 'yes') {
      return setMiniNavHeight(imageHeight, gallery);
    } else {
      return setImageHeight(imageHeight, gallery);
    }
  };

  resetFlexslider = function(gallery) {
    var imageHeight, size;
    size = getLargestImage(gallery);
    imageHeight = size['height'];
    return setImageHeight(imageHeight, gallery);
  };

  resetMiniFlexslider = function(gallery) {
    var imageHeight, size;
    size = getLargestImage(gallery);
    imageHeight = size['height'];
    return setMiniNavHeight(imageHeight, gallery);
  };

  $(function() {
    var galleries;
    galleries = $('.gallery');
    return galleries.each(function() {
      var gallery, galleryOptions;
      gallery = $(this);
      galleryOptions = JSON.parse(gallery.find('.config:first').html());
      setupFlexslider(galleryOptions, gallery);
      if (galleryOptions['mini_gallery'] === 'yes') {
        return $(window).smartresize(function() {
          return resetMiniFlexslider(gallery);
        });
      } else {
        return $(window).smartresize(function() {
          return resetFlexslider(gallery);
        });
      }
    });
  });

}).call(this);
