(function() {
  $(function() {
    $('.gallery-basic figure').hide().first().show();
    return setInterval((function() {
      return $('.gallery-basic figure:first').fadeOut(1000).next().fadeIn(1000).end().appendTo('.gallery-basic');
    }), 7000);
  });

}).call(this);
