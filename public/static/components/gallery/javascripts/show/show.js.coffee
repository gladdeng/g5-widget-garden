# Sets variables for the pieces of the gallery
gallery =
  flexContainer: $('.flexslider')
  wrapper: $('.slides')
  slides: $('.slides li')
  images: $('.slides img')

# Creates the slideshow
initializeFlexSlider = (galleryOptions, imageWidth) ->
  showThumbs = (if galleryOptions['show_thumbnails'] is "yes" then "thumbnails" else true)

  if (galleryOptions['carousel'] is 'yes')
    $('.gallery-carousel').flexslider
      animation: 'slide'
      animationLoop: false
      itemWidth: imageWidth
      itemMargin: 15

  else
    $('.gallery-slideshow').flexslider
      animation: 'fade'
      useCSS: true
      touch: true
      directionNav: true
      controlNav: showThumbs


  if galleryOptions['mini_gallery'] is 'no'
    # Set placement of gallery nav based on its height
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true)
    gallery.flexContainer.find('.flex-control-nav').css('bottom', -navHeight)
    gallery.flexContainer.css 'margin-bottom', -navHeight

# Gets the height of the tallest image
getLargestImage = ->
  gallery.slides.addClass 'loading'
  gallery.images.css 'max-height', 'none'
  imageHeight = 0
  imageWidth = 0
  size = []
  gallery.images.each ->
    curHeight = null
    curHeight = $(this).height()
    if curHeight > imageHeight
      imageHeight = curHeight
      imageWidth = $(this).width()

  gallery.slides.removeClass 'loading'
  size['height'] = imageHeight
  size['width'] = imageWidth
  size

# Sets max height of images so they all fit in the window
setImageHeight = (imageHeight) ->
  windowHeight = $(window).height()
  navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true)
  fixedHeight = null
  padding = 10

  if windowHeight <= imageHeight + navHeight
    fixedHeight = windowHeight - navHeight - padding

    if fixedHeight < 320
      fixedHeight = tallestImage - padding
  else
    fixedHeight = imageHeight - padding

  gallery.images.css 'max-height', fixedHeight
  gallery.slides.css 'height', fixedHeight
  gallery.flexContainer.find('.flex-control-nav').css 'bottom', -navHeight
  gallery.flexContainer.css 'margin-bottom', navHeight

setMiniNavHeight = (imageHeight) ->
  $('.flex-direction-nav a').height(imageHeight)

setupFlexslider = (galleryOptions) ->
  size = getLargestImage()
  imageHeight = size['height']
  imageWidth = size['width']

  initializeFlexSlider(galleryOptions, imageWidth)

  if galleryOptions['mini_gallery'] is 'yes'
    setMiniNavHeight imageHeight
  else
    setImageHeight imageHeight

resetFlexslider = ->
  size = getLargestImage()
  imageHeight = size['height']

  setImageHeight imageHeight

resetMiniFlexslider = ->
  size = getLargestImage()
  imageHeight = size['height']

  setMiniNavHeight imageHeight


$ ->
  galleryOptions = JSON.parse($('.gallery .config:first').html())

  setupFlexslider(galleryOptions)

  if galleryOptions['mini_gallery'] is 'yes'
    $(window).smartresize ->
      resetMiniFlexslider()
  else
    $(window).smartresize ->
      resetFlexslider()
