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

# Gets the height of the tallest caption
getTallestCaption = ->
  gallery.slides.addClass 'loading'
  tallestCaption = 0
  gallery.flexContainer.find('.flex-caption').each ->
    curHeight = null
    curHeight = $(this).outerHeight(true)
    tallestCaption = curHeight  if curHeight > tallestCaption

  gallery.slides.removeClass 'loading'
  tallestCaption

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
    navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight()
    captionHeight = getTallestCaption()
    bottomSpace = navHeight + captionHeight
    gallery.flexContainer.find('.flex-control-nav').css('bottom', -bottomSpace)
    gallery.flexContainer.css 'margin-bottom', -bottomSpace


# Sets max height of images so they all fit in the window
setImageHeight = (tallestImage) ->
  windowHeight = $(window).height()
  navHeight = gallery.flexContainer.find('.flex-control-nav').outerHeight(true)
  captionHeight = getTallestCaption()
  bottomSpace = navHeight + captionHeight
  fixedHeight = null
  padding = 10

  if windowHeight <= tallestImage + bottomSpace
    fixedHeight = windowHeight - navHeight - padding
  else
    fixedHeight = tallestImage - padding

  gallery.images.css 'max-height', fixedHeight
  gallery.slides.css 'height', fixedHeight
  gallery.flexContainer.css 'margin-bottom', bottomSpace

setupFlexslider = (galleryOptions) ->
  tallestImage = getTallestImage()
  initializeFlexSlider(galleryOptions)
  if galleryOptions['mini_gallery'] is 'no'
    setImageHeight tallestImage

resetFlexslider = ->
  tallestImage = getTallestImage()
  setImageHeight tallestImage

$ ->
  galleryOptions = JSON.parse($('.gallery .config:first').html())

  setupFlexslider(galleryOptions)

  $(window).smartresize ->
    if galleryOptions['mini_gallery'] is 'no'
      resetFlexslider()
