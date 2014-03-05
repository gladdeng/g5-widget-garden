# Sets variables for the pieces of the gallery
gallery =
  flexContainer: $('.flexslider')
  wrapper: $('.slides')
  slides: $('.slides li')
  images: $('.slides img')

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

# Creates the slideshow
initializeFlexSlider = ->
  galleryOptions = JSON.parse($('.gallery .config:first').html())
  gallery.flexContainer.flexslider
    animation: galleryOptions['animation']
    useCSS: true
    touch: true
    directionNav: true

  # Set placement of gallery nav based on its height
  navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight()
  gallery.flexContainer.css 'margin-bottom', navHeight
  gallery.flexContainer.find('.flex-control-nav').css 'bottom', -navHeight


# Sets max height of images so they all fit in the window
setImageHeight = (tallestImage) ->
  windowHeight = $(window).height()
  navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight()
  fixedHeight = null
  padding = 10

  if windowHeight <= tallestImage + navHeight
    fixedHeight = windowHeight - navHeight - padding
  else
    fixedHeight = tallestImage - padding

  gallery.images.css 'max-height', fixedHeight
  gallery.slides.css 'height', fixedHeight

setupFlexslider = ->
  tallestImage = getTallestImage()
  initializeFlexSlider()
  setImageHeight tallestImage

resetFlexslider = ->
  tallestImage = getTallestImage()
  gallery.slides.height 'auto'
  setImageHeight tallestImage

$ ->
  setupFlexslider()

  $(window).smartresize ->
    resetFlexslider()
