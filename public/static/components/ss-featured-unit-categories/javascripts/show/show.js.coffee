$ -> 
  configs = ssFeaturedUnitCategories
  #configs = JSON.parse($('#ss-featured-unit-categories-config').html())
  $.ajax
    #url: "#{configs.unit_service_host}"  #for local testing
    url: "#{configs.unit_service_host}/api/v1/storage_facilities/#{configs.location_urn}/storage_categories"
    dataType: 'json'
    success: (data) =>
      categories = data.storage_categories
      if typeof(categories) != "undefined" && categories.length > 0
        new ssUnitMarkupBuilder(categories, configs) 

class ssUnitMarkupBuilder 
  constructor: (categories, configs) ->
    categories.sort((a, b) -> return a.name - b.name)
    markupHash = []

    for category, index in categories
      markupHash.push(buttonTemplate(category.name, configs))

    allButton = " <div class='iui-size iui-view-all'>
                    <a class='btn' href='#{configs.unit_page_url}/#/category/all/units'>
                      View All
                    </a>
                  </div> "

    markupHash.push(allButton)

    $('.ss-featured-unit-categories .iui-container').html(markupHash.join(''))

  buttonTemplate = (name, configs) ->
    #buttonText = if name > 0 then "#{name} Bedroom" else "Studio"
    #buttonText = name.split(" ").join("")

    "<div class='iui-size'><a class='btn' href='#{configs.unit_page_url}/#/category/#{name}/units'>#{name}</a></div>"