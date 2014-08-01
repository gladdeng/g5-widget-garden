$ ->

  $('.coupon-drawer').hide()

  $('#show-coupon-form').on 'click', (e) ->
    $('#location-info').slideUp()
    $('#coupon-form').slideToggle()

  $('#show-location-info').on 'click', (e) ->
    $('#coupon-form').slideUp()
    $('#location-info').slideToggle()
