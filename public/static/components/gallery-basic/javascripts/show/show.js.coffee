$ ->

  # run every 7s
  setInterval (->
    $active = $(".gallery-basic .active")
    $next = (if ($active.next().length > 0) then $active.next() else $(".gallery-basic figure:first"))
    $next.css "z-index", 2 #move the next image up the pile
    $active.fadeOut 1500, -> #fade out the top image
      $active.css("z-index", 1).show().removeClass "active" #reset the z-index and unhide the image
      $next.css("z-index", 3).addClass "active" #make the next image the top one
  ), 7000
