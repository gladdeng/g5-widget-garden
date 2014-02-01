$ ->
  path = location.pathname
  $('[role=banner] .navigation a[href="' + path + '"]').addClass('active')
