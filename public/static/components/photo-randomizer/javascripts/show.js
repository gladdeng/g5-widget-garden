(function() {
  var randomPhoto;

  $(function() {
    var i, photoRandomizerVars, photos, random_photo;
    photoRandomizerVars = photoRandomizerVarsConfig;
    photos = [];
    i = 0;
    while (i < objects.length) {
      arr.push(objects[i].name);
      i++;
    }
    random_photo = photoRandomizerVars[Math.floor(Math.random() * items.length)];
    return $('.photo-randomizer').append(photoRandomizerMarkup);
  });

  randomPhoto = function(obj) {
    var keys;
    keys = Object.keys(obj);
    obj[keys[keys.length * Math.random() << 0]];
    return console.log(obj);
  };

}).call(this);
