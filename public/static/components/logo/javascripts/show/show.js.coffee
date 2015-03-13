$ ->
  logoVars = logoConfigs

  logoBuilder = (configs) ->
    if !window.location.origin
      window.location.origin = window.location.protocol + '//' + window.location.hostname + (if window.location.port then ':' + window.location.port else '')

    logo_canonical_url = window.location.origin

    #Determine single domain location url or primary domain url from config checkbox 
    if configs.single_domain_location is "true"
      #Filter pathname items and grab the first 3 based on G5 URL structure
      pathArray = window.location.pathname.split('/')
      cleanArray = pathArray.filter(Boolean)
      single_domain_path = ''
      logo_href = ''
      i = 0
      while i < 4
        single_domain_path += '/'
        single_domain_path += cleanArray[i]
        i++   
      logo_href = logo_canonical_url + single_domain_path
    else 
      #Primary domain URL
      logo_href = logo_canonical_url

    #Build out URL
    $('.logo.widget').attr('href', logo_href) if logo_href?

  logoBuilder(logoVars) if logoVars?