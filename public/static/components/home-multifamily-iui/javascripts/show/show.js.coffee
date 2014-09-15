$.ajax
  url: 'http://www.g5api.com/api/v0/multi_families?store_id=7337'
  dataType: 'json'
  success: (data) =>
    categories = data.unit_categories
    if typeof(categories) != "undefined" && categories.length > 0
      new iuiMarkupBuilder(categories) 



class iuiMarkupBuilder 
  constructor: (categories) ->
    # Might need to add a sort by beds if the API isn't doing that already
    markupHash = []

    for category, index in categories
      markupHash.push(buttonTemplate(category.beds))

    $('#googus').append(markupHash.join(''))

  buttonTemplate = (beds) ->
    "<h3>#{beds}</h3>"