(function() {
  $(function() {
    var ctasConfig, foo;
    ctasConfig = JSON.parse($('#foo-config').html());
    foo = ctasConfig['firstValue'];
    return alert("first_value = " + foo + "... js lives in ctas/javascripts/show/show.js.coffee");
  });

}).call(this);
