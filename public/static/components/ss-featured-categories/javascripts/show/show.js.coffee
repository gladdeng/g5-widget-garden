$ ->

  ssFeaturedUnitCat = JSON.parse($('#ss-featured-categories-config').html())

  $.ajax
    url: "#{ssFeaturedUnitCat.configuration}"
    dataType: 'json'
    success: (data) =>
      new LinkMaker(data).update()

class LinkMaker
  constructor: (@data) ->

  update: () ->
    #alert "(.Y.)"
    for category in @data.storage_categories
      $('.ss-featured-categories').append(@buttonTemplate(category)) 

  buttonTemplate: (category) ->
    "<div>
      <p>#{category.name}</p>
      <p>#{category.from_price}</p>
      <p>#{category.has_specials}</p>
    </div>"