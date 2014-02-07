$(window).load ->
  window_height = $(window).height()
  slider = $('.flexslider')
  images = slider.find('li img')
  max_height = 0
  flex_height = 0

  # Get height of tallest image
  images.each ->
    $(this).on 'load', ->
      cur_height = $(this).height()
      if cur_height > max_height
        max_height = cur_height

  # Compare window height to tallest image height
      if window_height < max_height
        flex_height = window_height-20
      else
        flex_height = max_height-20

  # Set container height and max image height
      slider.css('height', flex_height)
      images.css('max-height', flex_height)

  slider.flexslider
    "animation": "fade"
    "useCSS": true
    "touch": true
    "directionNav": true
