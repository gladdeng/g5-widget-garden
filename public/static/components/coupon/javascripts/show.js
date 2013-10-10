(function() {
  $('.coupon-print').live('click', function(e) {
    window.print();
    e.preventDefault();
  });
}).call(this);