class inputFields
  constructor: (@photo) ->

  markup: ->
    "<div>*** #{@photo.url} ***</div>"

$ -> 
  galleryOptions = JSON.parse($('.featured-properties-config').html())

  $('.photo-fields .form-field').hide()

  $('.data-summary .hide-inputs, .data-summary .show-inputs, .data-summary img').click( ->
    $(this).parent().siblings().slideToggle()
    $(this).parent().find('.show-inputs, .hide-inputs').slideToggle()
  )



  

 









