$ ->

  fields = $(".edit-social-links-widget").find "input"

  $.each fields, ->
    $(this).addClass "empty"  if $(this).val() is ""
