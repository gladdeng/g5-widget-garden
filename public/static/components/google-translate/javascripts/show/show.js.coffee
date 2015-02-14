googleTranslateElementInit = (languages) ->
  new google.translate.TranslateElement({pageLanguage: 'en', includedLanguages: languages, layout: google.translate.TranslateElement.InlineLayout.SIMPLE, autoDisplay: false}, 'google_translate_element')

$ ->
  configOpts = $('#google-translate-config')
  if configOpts.length
    configs = JSON.parse(configOpts.html())
    languages = configs.languages
    googleTranslateElementInit(languages)
