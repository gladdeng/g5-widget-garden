(->
  $(".coupon-print").live "click", (e) ->
    window.print()
    e.preventDefault()
).call this