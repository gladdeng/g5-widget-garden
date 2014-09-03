$ ->
  path = location.pathname.match(/([^\/]*)\/*$/)[1]
  $('[role=banner] .navigation a[href*="/' + path + '"]').addClass('active') unless path is ""
