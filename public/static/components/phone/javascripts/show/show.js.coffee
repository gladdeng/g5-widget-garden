$ ->
  phoneOptions = JSON.parse($('.phone .config:first').html())
  new phoneNumber(phoneOptions)
