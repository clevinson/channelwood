/*

  DRAGGING
  &
  FADING

  *used mostly by physical release pages

*/
var $viewWidth;
var $textboxWidth;
$(function() {
  $('.drag').draggable();
  $('#back-images').click(function() {
    $('.info').fadeToggle(300);
    $('footer').fadeToggle(300);
  });
  $textboxWidth = $('.textbox').width();
  $viewWidth = $(window).width();
  $(window).on('resize', function(){
    $viewWidth = $(window).width();
    checkTextBoxVisibility();
  });
  checkTextBoxVisibility();
});
function checkTextBoxVisibility() {
  if ($viewWidth < $textboxWidth) {
    $('.textbox').draggable('disable');
  } else {
    $('.textbox').draggable('enable');
  }
}

/*

  CENTERING
  VERTICALLY

  *used mostly by the homepage

*/
var $viewHeight;
var $listHeight;
$(function() {
  // gather height of viewport height (window - footer) and list (homepage list of releases)
  $(window).on('resize', function(){
    $viewHeight = $(window).height() - $('#footer nav').height();
    checkListMargin();
  });
  $viewHeight = $(window).height() - $('#footer nav').height();
  $listHeight = $('#the-list').height();
  checkListMargin();
});
// the basic logic:
//    • if the window is taller than the list, center the list vertically
//    • if the window is shorter than the list, do not center
function checkListMargin() {
  var topMargin = $viewHeight/2 - $listHeight/2;
  if ($viewHeight > $listHeight) {
    $('#the-list').css('margin-top', topMargin);
  } else {
    $('#the-list').css('margin-top', '0px');
  }
}