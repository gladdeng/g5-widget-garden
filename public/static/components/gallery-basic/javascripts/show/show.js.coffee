nextImage = ->
  $active = $(".gallery-basic .active")
  $next = (if $active.next().length > 0 then $active.next() else $(".gallery-basic figure:first"))
  loading = false # keeps track of whether an image is being loaded

  # check if next image needs to be loaded
  if $next.hasClass "lazy-load"
    loading = true
    $img = $next.find "img"
    src = $img.attr "data-src"
    $img.attr "src", src
    $next.removeClass "lazy-load"
    $img.on 'load', ->
      loading = false

  # when images are done loading, transition to next slide
  if loading is false
    $next.css "z-index", 2
    $active.fadeOut 1500, ->
      $active.css("z-index", 1).show().removeClass "active"
      $next.css("z-index", 3).addClass "active"


# Change slide every 7 seconds
setInterval (->
  nextImage()
), 7000
