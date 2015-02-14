(function() {
  var googleTranslateElementInit;

  googleTranslateElementInit = function(languages) {
    return new google.translate.TranslateElement({
      pageLanguage: 'en',
      includedLanguages: languages,
      layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
      autoDisplay: false
    }, 'google_translate_element');
  };

  $(function() {
    var configOpts, configs, languages;
    configOpts = $('#google-translate-config');
    if (configOpts.length) {
      configs = JSON.parse(configOpts.html());
      languages = configs.languages;
      return googleTranslateElementInit(languages);
    }
  });

}).call(this);
