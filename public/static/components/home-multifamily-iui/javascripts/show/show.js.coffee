$ -> 
  configOpts = $('#home-multifamily-iui-config')
  return unless configOpts.length
  configs = JSON.parse(configOpts.html())

  $.ajax
    url: "#{configs.floorplans_service_host}/api/v0/multi_families?store_id=#{configs.core_store_id}"
    dataType: 'json'
    success: (data) =>
      categories = data.unit_categories
      if typeof(categories) != "undefined" && categories.length > 0
        new iuiMarkupBuilder(categories, configs) 

class iuiMarkupBuilder 
  constructor: (categories, configs) ->
    categories.sort((a, b) -> return a.beds - b.beds)
    markupHash = []

    for category, index in categories
      markupHash.push(buttonTemplate(category.beds, configs))

    allButton = " <div class='iui-size iui-view-all'>
                    <a class='btn' href='#{configs.floorplan_page_url}/#/bedrooms/all/floorplans'>
                      View All
                    </a>
                  </div> "

    markupHash.push(allButton)

    $('.home-multifamily-iui .iui-container').html(markupHash.join(''))

  buttonTemplate = (beds, configs) ->
    buttonText = if beds > 0 then "#{beds} Bedroom" else "Studio"
    "<div class='iui-size'><a class='btn' href='#{configs.floorplan_page_url}#/bedrooms/#{beds}/floorplans'>#{buttonText}</a></div>"
