$(function() {
  $('.drag').draggable();
  $('#back-images').click(function() {
    $('.info').fadeToggle(300);
    $('footer').fadeToggle(300);
  });
});