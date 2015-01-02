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
  configs: null
  constructor: (categories, @configs) ->
    categories.sort((a, b) -> return a.name - b.name)
    markupHash = []

    for category, index in categories
      markupHash.push(@buttonTemplate(category, @configs))

    allButton = " <div class='iui-size iui-view-all'>
                    <a class='btn' href='#{@unitPageUrl()}/#/size'>
                      View All
                    </a>
                  </div> "

    markupHash.push(allButton)

    $('.ss-featured-unit-categories .iui-container').html(markupHash.join(''))

  buttonTemplate: (category, configs) ->
    #buttonText = if name > 0 then "#{name} Bedroom" else "Studio"
    #buttonText = name.split(" ").join("")

    "<div class='iui-size'><a class='btn' href='#{@unitPageUrl()}/#/options?categoryId=#{category.id}'>#{category.name}</a></div>"

  unitPageUrl: ->
    if @configs.unit_page_url.indexOf('http') != -1
      return @configs.unit_page_url
    else
      return "#{document.location.href}/#{@configs.unit_page_url}"