$ ->
  $('.gallery-basic figure').hide().first().show()

  setInterval (->
    $('.gallery-basic figure:first')
      .fadeOut(1000)
      .next()
      .fadeIn(1000)
      .end()
      .appendTo '.gallery-basic'
    ), 3000