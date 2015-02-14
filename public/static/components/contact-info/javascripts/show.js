(function() {
  $(function() {
    var configOpts, phoneOptions;
    configOpts = $('.contact-info .config:first');
    if (configOpts.length) {
      phoneOptions = JSON.parse(configOpts.html());
      return new phoneNumber(phoneOptions);
    }
  });

}).call(this);
