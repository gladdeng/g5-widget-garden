$ ->
  # Get photo randomizer config options
  photoRandomizerVars = photoRandomizerVarsConfig  

  # PHOTO RANDOMIZER UTILITIES
  # *******************
  #Grab up all the URLs & alt text from the Configs in an array
  photo_array = photoRandomizerVars.photos
  
  #Randomize the array that has been cleaned up
  random_photo = photo_array[Math.floor(Math.random()*photo_array.length)]

  #Build out the random image
  photoRandomizerBuilder = (data)  ->
    if data != []
      #clean up array of undefined values

      photoRandomizerMarkup = """<img src="#{data.url}" alt="#{data.alt_text}"/>"""
      $('.photo-randomizer').append(photoRandomizerMarkup)

  photoRandomizerBuilder(random_photo) if random_photo.length > 1