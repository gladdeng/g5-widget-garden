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
  nav_height = 33

  # Get height of tallest image
  slides.each ->
    cur_height = $(this).find('img').height()
    if cur_height > tallest_image
      tallest_image = cur_height

  slides.removeClass('loading')

  # Compare window height to tallest image height
  if window_height < tallest_image + nav_height
    wrapper_height = window_height
    image_height = window_height - nav_height
  else
    wrapper_height = tallest_image + nav_height
    image_height = tallest_image

  # Set container height and max image height
  wrapper.css('height', wrapper_height)
  images.css('max-height', image_height)

$ ->
  # Set heights of flexslider container and images
  setupFlexslider()

  $(window).resize ->
    setupFlexslider()

  # Instanciate Flexslider Plugin
  $('.flexslider').flexslider
    animation: "fade"
    useCSS: true
    touch: true
    directionNav: true
