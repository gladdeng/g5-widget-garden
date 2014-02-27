# Sets variables for the pieces of the gallery
gallery =
  wrapper: $(".slides")
  slides: $(".slides li")
  images: $(".slides img")

# Gets the height of the tallest image
getTallestImage = ->
  gallery.slides.addClass "loading"
  gallery.images.css "max-height", "none"
  tallest_image = 0
  gallery.images.each ->
    cur_height = null
    cur_height = $(this).height()
    tallest_image = cur_height  if cur_height > tallest_image
    return

  gallery.slides.removeClass "loading"
  tallest_image

# Creates the slideshow
initializeFlexSlider = ->
  galleryOptions = JSON.parse($(".gallery .config:first").html())
  $(".flexslider").flexslider
    animation: galleryOptions["animation"]
    useCSS: true
    touch: true
    directionNav: true

# Sets max height of images so they all fit in the window
setImageHeight = (tallest_image) ->
  window_height = $(window).height()
  nav_height = $(".flexslider .flex-control-nav").outerHeight()
  fixed_height = null
  if window_height <= tallest_image + nav_height
    fixed_height = window_height - nav_height - 10
  else
    fixed_height = tallest_image - 10
  gallery.images.css "max-height", fixed_height

setupFlexslider = ->
  tallest_image = getTallestImage()
  initializeFlexSlider()
  setImageHeight tallest_image

resetFlexslider = ->
  tallest_image = getTallestImage()
  setImageHeight tallest_image

$ ->
  setupFlexslider()
  $(window).smartresize ->
    resetFlexslider()