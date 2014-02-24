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


setupFlexslider = ->
  # Slider Elements
  wrapper = $('.flexslider-container')
  slides = wrapper.find('.flexslider li').addClass('loading')
  images = slides.find('img')

  # Sizing Variables
  window_height = $(window).height()
  tallest_image = 0
  wrapper_height = 0
  image_height = 0
  bottom_space =

  # Get height of tallest image
  slides.each ->
    cur_height = $(this).find('img').height()
    if cur_height > tallest_image
      tallest_image = cur_height

  slides.removeClass('loading')

  # Compare window height to tallest image height
  if window_height < tallest_image + bottom_space
    wrapper_height = window_height
    image_height = window_height - bottom_space
  else
    wrapper_height = tallest_image + bottom_space
    image_height = tallest_image

  # Set container height and max image height
  wrapper.css('height', wrapper_height)
  images.css('max-height', image_height)


resetFlexslider = ->
  wrapper = $('.flexslider-container')
  images = wrapper.find('.slides img')

  wrapper.css('height', 'auto')
  images.css('max-height', 'none')

  setupFlexslider()


$ ->
