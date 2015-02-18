$ ->
  # Get photo randomizer config options
  photoRandomizerVars = photoRandomizerVarsConfig  

  # PHOTO RANDOMIZER UTILITIES
  # *******************
  #Grab up all the URLs & alt text from the Configs in an array
  photo_array = photoRandomizerVars.photos
  
  #Randomize some stuff by passing it the array
  random_photo = photo_array[Math.floor(Math.random()*photo_array.length)];

  #Build out the random image
  photoRandomizerBuilder = (data) ->
    if data != []
      photoRandomizerMarkup = """<img src="#{data.url}" alt="#{data.alt_text}"/>"""
      $('.photo-randomizer').append(photoRandomizerMarkup)

  photoRandomizerBuilder(random_photo) if photo_array.length > 1

# The Module Pattern
# $ ->
#   photoRandomizerVars = photoRandomizerVarsConfig    
  # Setup
#   new photoRandomizerInitializer(photoRandomizerVars) if photoRandomizerVars?


# class photoRandomizerInitializer
#   constructor: (@configs) ->
#   randomPhoto: () ->
#     constructor: @obj
#     keys = Object.keys(@obj)
#     @obj[keys[keys.length * Math.random() << 0]]
#     console.log(@obj)

#   photoRandomizerBuilder: () ->
#     contstructor: @dataFeed
#     if dataFeed != []
#       photoRandomizerMarkup = """<img src="#{@dataFeed.url}" alt="#{@dataFeed.alt_text}"/>"""
#       $('.photo-randomizer').append(photoRandomizerMarkup)