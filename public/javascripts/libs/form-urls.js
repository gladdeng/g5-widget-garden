(function() {

  var canonicalUrl = function() {
    var inputs = $('input.u-canonical');
    var loc = $(location).attr('href');
    inputs.val(loc);
  };

  $(function() {
    canonicalUrl();
  });

}).call(this);
