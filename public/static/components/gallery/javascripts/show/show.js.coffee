# debouncing function from John Hann
# http://unscriptable.com/index.php/2009/03/20/debouncing-javascript-methods/
(($, sr) ->
  debounce = (func, threshold, execAsap) ->
    timeout = undefined
    debounced = ->
      delayed = ->
        func.apply obj  unless execAsap
        timeout = null
        return
      obj = this
      if timeout
        clearTimeout timeout
      else func.apply obj  if execAsap
      timeout = setTimeout(delayed, threshold or 100)
      return

  # smartresize
  jQuery.fn[sr] = (fn) ->
    (if fn then @bind("resize", debounce(fn)) else @trigger(sr))

  return
) jQuery, "smartresize"


getTallestImage = ->

setupFlexslider = ->
  # Slider Elements
  wrapper = $('.slides')
  slides = wrapper.find('li').addClass('loading')
  images = wrapper.find('img')

  # Sizing Variables
  window_height = $(window).height()
  tallest_image = 0
  fixed_height = 0

  # Get height of tallest image
  images.each ->
    cur_height = $(this).height()
    if cur_height > tallest_image
      tallest_image = cur_height

  slides.removeClass('loading')

  # Instanciate Flexslider Plugin
  galleryOptions = JSON.parse($(".gallery .config:first").html())
  $(".flexslider").flexslider
    animation: galleryOptions['animation']
    useCSS: true
    touch: true
    directionNav: true

  nav_height = $('.flexslider .flex-control-nav').outerHeight()

  # Compare window height to tallest image height
  if window_height <= tallest_image + nav_height
    fixed_height = window_height - nav_height
  else
    fixed_height = tallest_image

  # Set container height and max image height
  images.css('max-height', fixed_height)


resetFlexslider = ->

  # Slider Elements
  wrapper = $('.slides')
  slides = wrapper.find('li').addClass('loading')
  images = wrapper.find('img').css('max-height', 'none')

  # Sizing Variables
  window_height = $(window).height()
  tallest_image = 0
  fixed_height = 0


  # Get height of tallest image
  images.each ->
    cur_height = $(this).height()
    if cur_height > tallest_image
      tallest_image = cur_height

  slides.removeClass('loading')

  nav_height = $('.flexslider .flex-control-nav').outerHeight()

  # Compare window height to tallest image height
  if window_height <= tallest_image + nav_height
    fixed_height = window_height - nav_height
  else
    fixed_height = tallest_image

  # Set container height and max image height
  images.css('max-height', fixed_height)


$ ->
  # Set heights of flexslider container and images
  setupFlexslider()

  $(window).smartresize ->
    resetFlexslider()


