$ ->
  configOpts = $('.contact-info .config:first')
  if configOpts.length
    phoneOptions = JSON.parse(configOpts.html())
    new phoneNumber(phoneOptions)
