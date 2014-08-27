$ ->

  ctasConfig = JSON.parse($('#foo-config').html())
  foo = ctasConfig['firstValue']

  alert "first_value = #{foo}... js lives in ctas/javascripts/show/show.js.coffee"