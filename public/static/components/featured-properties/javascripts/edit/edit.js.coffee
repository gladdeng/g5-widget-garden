class inputFields
  constructor: (@photo) ->

  markup: ->
    "<div>*** #{@photo.url} ***</div>"

$ -> 
  galleryOptions = JSON.parse($('.featured-properties-config').html())
  markup = ""

  for photo, index in galleryOptions.photos
    photoMarkup = new inputFields photo
    markup += photoMarkup.markup()

  $('.photo-fields').append(markup)

 









