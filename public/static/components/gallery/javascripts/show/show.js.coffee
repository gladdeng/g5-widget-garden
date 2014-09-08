# Sets variables for the pieces of the gallery
gallery =
  flexContainer: $('.flexslider')
  wrapper: $('.slides')
  slides: $('.slides li')
  images: $('.slides img')

# Creates the slideshow
initializeFlexSlider = (galleryOptions) ->
  showThumbs = (if galleryOptions['show_thumbnails'] is "yes" then "thumbnails" else true)

  gallery.flexContainer.flexslider
    animation: galleryOptions['animation']
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
getTallestImage = ->
  gallery.slides.addClass 'loading'
  gallery.images.css 'max-height', 'none'
  tallestImage = 0
  gallery.images.each ->
    curHeight = null
    curHeight = $(this).height()
    tallestImage = curHeight  if curHeight > tallestImage

  gallery.slides.removeClass 'loading'
  tallestImage

# Sets max height of images so they all fit in the window
setImageHeight = (tallestImage) ->
  windowHeight = $(window).height()
  navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true)
  fixedHeight = null
  padding = 10

  if windowHeight <= tallestImage + navHeight
    fixedHeight = windowHeight - navHeight - padding

    if fixedHeight < 320
      fixedHeight = tallestImage - padding
  else
    fixedHeight = tallestImage - padding

  gallery.images.css 'max-height', fixedHeight
  gallery.slides.css 'height', fixedHeight
  gallery.flexContainer.find('.flex-control-nav').css 'bottom', -navHeight
  gallery.flexContainer.css 'margin-bottom', navHeight

setMiniNavHeight = (tallestImage) ->
  $('.flex-direction-nav a').height(tallestImage)

setupFlexslider = (galleryOptions) ->
  tallestImage = getTallestImage()
  initializeFlexSlider(galleryOptions)

  if galleryOptions['mini_gallery'] is 'yes'
    setMiniNavHeight tallestImage
  else
    setImageHeight tallestImage

resetFlexslider = ->
  tallestImage = getTallestImage()
  setImageHeight tallestImage

resetMiniFlexslider = ->
  tallestImage = getTallestImage()
  setMiniNavHeight tallestImage


$ ->
  galleryOptions = JSON.parse($('.gallery .config:first').html())

  setupFlexslider(galleryOptions)

  if galleryOptions['mini_gallery'] is 'yes'
    $(window).smartresize ->
      resetMiniFlexslider()
  else
    $(window).smartresize ->
      resetFlexslider()
