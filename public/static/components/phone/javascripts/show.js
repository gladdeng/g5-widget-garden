(function() {
  $(function() {
    var gigity, phoneOptions;
    phoneOptions = JSON.parse($('.phone .config:first').html());
    if (phoneOptions.displayPhone === "true") {
      new phoneNumber(phoneOptions);
    }
    if (phoneOptions.appendPhone === "true") {
      return gigity = "goo";
    }
  });

}).call(this);
