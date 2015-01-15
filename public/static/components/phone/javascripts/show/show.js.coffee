$ ->
  phoneOptions = JSON.parse($('.phone .config:first').html())

  if phoneOptions.displayPhone == "true"
    new phoneNumber(phoneOptions)

  if phoneOptions.appendPhone == "true"
    # go stick the phone number in other places, too
