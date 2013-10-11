(function() {
  (function() {
    return $(".coupon-print").live("click", function(e) {
      window.print();
      return e.preventDefault();
    });
  }).call(this);

}).call(this);
