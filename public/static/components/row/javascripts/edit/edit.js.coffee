chooseLayout = $(".select-row-layout")
selectedLayout = chooseLayout.val()

$('.col-widgets').hide()
$('.' + selectedLayout).show()

chooseLayout.on 'change', ->
  selectedLayout = $(this).val()
  $('.col-widgets').hide()
  $('.' + selectedLayout).show()
