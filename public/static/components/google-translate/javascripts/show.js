(function() {
  var googleTranslateElementInit;

  googleTranslateElementInit = function() {
    return new google.translate.TranslateElement({
      pageLanguage: 'en',
      includedLanguages: 'cs,de,en,es,fr,hr,hy,id,it,iw,ja,ko,lt,pl,ru,tl,zh-CN',
      layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
      autoDisplay: false
    }, 'google_translate_element');
  };

  $(function() {
    return googleTranslateElementInit();
  });

}).call(this);
