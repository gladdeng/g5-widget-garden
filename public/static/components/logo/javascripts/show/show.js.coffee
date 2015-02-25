$ ->
  logo_canonical_url = window.location.origin
  logo_home_link = if logo_canonical_url.length > 1 then logo_canonical_url else '/'
  $('.logo.widget').attr('href', logo_home_link)
  # $('.logo.widget').click ->
  #   this.attr('href', logo_home_link)
  #   false