$ -> 
  configs = JSON.parse($('#home-multifamily-iui-config').html())

  $.ajax
    url: "http://www.g5api.com/api/v0/multi_families?store_id=#{configs.core_store_id}"
    dataType: 'json'
    success: (data) =>
      categories = data.unit_categories
      if typeof(categories) != "undefined" && categories.length > 0
        new iuiMarkupBuilder(categories, configs) 

class iuiMarkupBuilder 
  constructor: (categories, configs) ->
    # Might need to add a sort by beds if the API isn't doing that already
    markupHash = []

    for category, index in categories
      markupHash.push(buttonTemplate(category.beds, configs))

    markupHash.push("<div class='iui-size iui-view-all'><a class='btn' href=''>View All</a></div>")

    $('.home-multifamily-iui .iui-container').html(markupHash.join(''))

  buttonTemplate = (beds, configs) ->
    # Still need some Bedrooms vs Studio logic in here

    "<div class='iui-size'><a class='btn' href='#{configs.floorplan_page_url}#/bedrooms/#{beds}/floorplans'>#{beds} Bedroom</a></div>"