var localPath = window.location.href;
$.each($('.social-links use'), function() {
  $(this).attr('xlink:href', localPath + $(this).attr('xlink:href'));
});