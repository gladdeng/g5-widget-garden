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
    return

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
    after: (slider) ->
      currHeight = gallery.slides.eq(slider.currentSlide).outerHeight(true)
      gallery.flexContainer.height(currHeight)
      gallery.wrapper.height(currHeight)

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

setupFlexslider = ->
  tallestImage = getTallestImage()
  initializeFlexSlider()
  setImageHeight tallestImage

resetFlexslider = ->
  tallestImage = getTallestImage()
  setImageHeight tallestImage
  gallery.wrapper.height 'auto'

$ ->
  setupFlexslider()

  $(window).smartresize ->
    resetFlexslider()
