# Creates the slideshow
initializeFlexSlider = (galleryOptions, imageWidth, gallery) ->
  showThumbs = (if galleryOptions['show_thumbnails'] is "yes" then "thumbnails" else true)

  if (galleryOptions['carousel'] is 'yes')
    gallery.find('.gallery-carousel').flexslider
      animation: 'slide'
      animationLoop: false
      itemWidth: imageWidth
      itemMargin: 15

  else
    gallery.find('.gallery-slideshow').flexslider
      animation: 'fade'
      useCSS: true
      touch: true
      directionNav: true
      controlNav: showThumbs


  if galleryOptions['mini_gallery'] is 'no'
    # Set placement of gallery nav based on its height
    navHeight = gallery.find('.flex-control-nav').outerHeight(true)
    gallery.find('.flex-control-nav').css('bottom', -navHeight)
    gallery.find('.flexslider').css 'margin-bottom', -navHeight

# Gets the height of the tallest image
getLargestImage = (gallery) ->
  slides = gallery.find('.slides li')
  images = gallery.find('.slides img')

  slides.addClass 'loading'
  images.css 'max-height', 'none'
  imageHeight = 0
  imageWidth = 0
  size = []
  images.each ->
    curHeight = null
    curHeight = $(this).height()
    if curHeight > imageHeight
      imageHeight = curHeight
      imageWidth = $(this).width()

  slides.removeClass 'loading'
  size['height'] = imageHeight
  size['width'] = imageWidth
  size

# Sets max height of images so they all fit in the window
setImageHeight = (imageHeight, gallery, carousel) ->
  galleryType = (if carousel is "yes" then "carousel" else "slideshow")
  windowHeight = $(window).height()
  navHeight = gallery.find('.flex-control-nav').outerHeight true
  fixedHeight = null
  padding = 10

  if windowHeight <= imageHeight + navHeight
    fixedHeight = windowHeight - navHeight - padding

    if fixedHeight < 320
      fixedHeight = imageHeight - padding
  else
    fixedHeight = imageHeight - padding

  if galleryType == 'carousel'
    gallery.find('.slides img').css 'max-height', imageHeight
    gallery.find('.slides li').css 'height', imageHeight
  else
    gallery.find('.slides img').css 'max-height', fixedHeight
    gallery.find('.slides li').css 'height', fixedHeight

  gallery.find('.flex-control-nav').css 'bottom', -navHeight
  gallery.find('.flexslider').css 'margin-bottom', navHeight

setMiniNavHeight = (imageHeight, gallery) ->
  gallery.find('.flex-direction-nav a').height imageHeight

setupFlexslider = (galleryOptions, gallery) ->
  size = getLargestImage(gallery)
  imageHeight = size['height']
  imageWidth = size['width']

  initializeFlexSlider(galleryOptions, imageWidth, gallery)

  if galleryOptions['mini_gallery'] is 'yes'
    setMiniNavHeight imageHeight, gallery
  else
    setImageHeight imageHeight, gallery, galleryOptions['carousel']

resetFlexslider = (gallery) ->
  size = getLargestImage(gallery)
  imageHeight = size['height']

  setImageHeight imageHeight, gallery

resetMiniFlexslider = (gallery) ->
  size = getLargestImage(gallery)
  imageHeight = size['height']

  setMiniNavHeight imageHeight, gallery


$ ->
  galleries = $('.gallery')

  galleries.each ->

    gallery = $(this)

    galleryOptions = JSON.parse(gallery.find('.config:first').html())

    setupFlexslider galleryOptions, gallery

    if galleryOptions['mini_gallery'] is 'yes'
      $(window).smartresize ->
        resetMiniFlexslider gallery
    else
      $(window).smartresize ->
        resetFlexslider gallery
