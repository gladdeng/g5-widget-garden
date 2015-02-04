$ ->
  # Get realpage config options
  realPageVars = realPageVarsConfig   
  
  # RealPage Script URL Builder
  realPageJSBuilder = (configs) ->
    console.log(configs)
    target_div_param = "&container=realpage-iframe"
    realpage_url =
      if configs.realpage_stylesheet.length > 1 and configs.realpage_id.length > 1
        "#{configs.realpage_id}#{target_div_param}&css=https%3A#{configs.realpage_stylesheet}"
      else if configs.realpage_id.length > 1 
        "#{configs.realpage_id}#{target_div_param}"
    console.log(realpage_url)
    realPageJS = """<SCRIPT language="javascript" src="https://property.onesite.realpage.com/oll/eol/widget?siteId=#{ realpage_url }"></SCRIPT>"""
    $('.realpage.widget').append(realPageJS) if realpage_url?

  realPageJSBuilder(realPageVars) if realPageVars?