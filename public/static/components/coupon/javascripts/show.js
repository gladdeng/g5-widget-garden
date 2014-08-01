(function() {
  $(function() {
    $('.coupon-drawer').hide();
    $('#show-coupon-form').on('click', function(e) {
      $('#location-info').slideUp();
      return $('#coupon-form').slideToggle();
    });
    return $('#show-location-info').on('click', function(e) {
      $('#coupon-form').slideUp();
      return $('#location-info').slideToggle();
    });
  });

}).call(this);
