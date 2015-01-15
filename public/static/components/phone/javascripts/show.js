(function() {
  $(function() {
    var phoneOptions;
    phoneOptions = JSON.parse($('.phone .config:first').html());
    if (phoneOptions.displayPhone === "true") {
      new phoneNumber(phoneOptions);
    }
    if (phoneOptions.appendPhone === "true") {
      return alert("(.Y.)");
    }
  });

}).call(this);
