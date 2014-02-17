(function() {
  $(function() {
    var phoneOptions;
    phoneOptions = JSON.parse($('.phone .config:first').html());
    return new phoneNumber(phoneOptions);
  });

}).call(this);
