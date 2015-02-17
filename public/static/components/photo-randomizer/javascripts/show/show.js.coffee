$ ->
  # Get photo randomizer config options
  photoRandomizerVars = photoRandomizerVarsConfig  
  # Setup
  # if photoRandomizerVars.length > 1
  #   photoRandomizer = new photoRandomizerInitializer(photoRandomizerVars)

# PHOTO RANDOMIZER UTILITIES
# *******************
  #Grab up all the URLs & alt text from the Configs
  #photoRandomizerVars = photoRandomizerVarsConfig 

  #Smash all the results into an array?  Need Utility that accepts
  photos = []
  i = 0
  while i < objects.length
    arr.push objects[i].name
    i++

  #Grab a Random item from the Array and assign it to variable
  random_photo = photoRandomizerVars[Math.floor(Math.random()*items.length)]

  #append arrayRandom to some html element
  $('.photo-randomizer').append(photoRandomizerMarkup)


randomPhoto = (obj) ->
  keys = Object.keys(obj)
  obj[keys[keys.length * Math.random() << 0]]
  console.log(obj)



