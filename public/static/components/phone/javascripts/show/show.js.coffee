$ ->
  configOpts = $('.phone .config:first')
  return unless configOpts.length
  phoneOptions = JSON.parse(configOpts.html())

  if phoneOptions.appendPhone == 'true'
    phoneMarkup = " <a href='tel://#{phoneOptions.defaultPhoneNumber}' class='appended-phone number h-card vcard' itemscope itemtype='http://schema.org/LocalBusiness' >
                      <span style='visibility:hidden;' class='p-tel tel' itemprop='telephone'>#{phoneOptions.defaultPhoneNumber}</span>
                    </a> "

    $(phoneMarkup).insertAfter("#{phoneOptions.appendElements}")

  new phoneNumber(phoneOptions)
