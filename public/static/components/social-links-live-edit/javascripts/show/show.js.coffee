$ ->

  inputs = $(".edit-social-links-widget").find("input")

  $.each inputs, ->
    $(this).addClass "empty"  if $(this).value is ""
