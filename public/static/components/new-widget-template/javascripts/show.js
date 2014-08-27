(function() {
  $(function() {
    var foo, fooConfig;
    fooConfig = JSON.parse($('#foo-config').html());
    foo = fooConfig['firstValue'];
    return alert("first_value = " + foo + "... js lives in ctas/javascripts/show/show.js.coffee");
  });

}).call(this);
