(function() {
  var gallery, getTallestCaption, getTallestImage, initializeFlexSlider, resetFlexslider, resetMiniFlexslider, setImageHeight, setMiniNavHeight, setupFlexslider;

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

  getTallestCaption = function() {
    var tallestCaption;
    gallery.slides.addClass('loading');
    tallestCaption = 0;
    gallery.flexContainer.find('.flex-caption').each(function() {
      var curHeight;
      curHeight = null;
      curHeight = $(this).outerHeight(true);
      if (curHeight > tallestCaption) {
        return tallestCaption = curHeight;
      }
    });
    gallery.slides.removeClass('loading');
    return tallestCaption;
  };

  initializeFlexSlider = function(galleryOptions) {
    var bottomSpace, captionHeight, navHeight, showThumbs;
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
      bottomSpace = navHeight + captionHeight;
      gallery.flexContainer.find('.flex-control-nav').css('bottom', -bottomSpace);
      return gallery.flexContainer.css('margin-bottom', -bottomSpace);
    }
  };

  setImageHeight = function(tallestImage) {
    var bottomSpace, captionHeight, fixedHeight, navHeight, padding, windowHeight;
    windowHeight = $(window).height();
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true);
    captionHeight = getTallestCaption();
    bottomSpace = navHeight + captionHeight;
    fixedHeight = null;
    padding = 10;
    if (windowHeight <= tallestImage + bottomSpace) {
      fixedHeight = windowHeight - navHeight - padding;
    } else {
      fixedHeight = tallestImage - padding;
    }
    gallery.images.css('max-height', fixedHeight);
    gallery.slides.css('height', fixedHeight);
    return gallery.flexContainer.css('margin-bottom', bottomSpace);
  };

  setMiniNavHeight = function(tallestImage) {
    return $('.flex-direction-nav a').height(tallestImage);
  };

  setupFlexslider = function(galleryOptions) {
    var tallestImage;
    tallestImage = getTallestImage();
    initializeFlexSlider(galleryOptions);
    if (galleryOptions['mini_gallery'] === 'no') {
      setImageHeight(tallestImage);
    }
    if (galleryOptions['mini_gallery'] === 'yes') {
      return setMiniNavHeight(tallestImage);
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
    if (galleryOptions['mini_gallery'] === 'no') {
      $(window).smartresize(function() {
        return resetFlexslider();
      });
    }
    if (galleryOptions['mini_gallery'] === 'yes') {
      return $(window).smartresize(function() {
        return resetMiniFlexslider();
      });
    }
  });

}).call(this);
