(function() {

  var canonicalUrl = function() {
    var inputs = $('input.u-canonical');
    var loc = $(location).attr('href');
    inputs.val(loc);
  };

  var tits = function() {
    var clientUrn;
    clientUrn = JSON.parse($('.contact-info-sheet-config:first').html());
    canonicalUrl();
  };

  // if ($('.g5-enhanced-form .config').length > 0) {
  //   tits();
  // }

  myFunc = function() {
  if (document.getElementById('#tits')) {
      tits();
    } else {
      setTimeout(myFunc, 15);
    }
  }

  myFunc();
  debugger;
  

  // $( '.g5-enhanced-form .config' ).ready( handler )



  // $(function() {
  //   var clientUrn;
  //   clientUrn = JSON.parse($('.g5-enhanced-form .config:first').html());
  //   canonicalUrl();
  // });

}).call(this);
