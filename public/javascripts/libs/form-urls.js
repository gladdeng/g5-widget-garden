(function() {

  var canonicalUrl = function() {
    var inputs = $('input.u-canonical');
    var loc = $(location).attr('href');
    inputs.val(loc);
  };

  $(function() {
    var clientUrn;
    $('.g5-enhanced-form').load(function() {
      clientUrn = JSON.parse($('.g5-enhanced-form .config:first').html());
      canonicalUrl();
    });
    
  });

}).call(this);
