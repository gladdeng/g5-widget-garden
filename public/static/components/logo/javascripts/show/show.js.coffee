$ ->
  logoVars = logoConfigs

  logoBuilder = (configs) ->
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
    $('.logo.widget').prop('href', logo_href) if logo_href?

  logoBuilder(logoVars) if logoVars?