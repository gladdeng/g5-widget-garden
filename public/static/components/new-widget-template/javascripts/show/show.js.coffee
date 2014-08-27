$ ->

  fooConfig = JSON.parse($('#foo-config').html())
  foo = fooConfig['firstValue']

  alert "first_value = #{foo}... js lives in ctas/javascripts/show/show.js.coffee"