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

  CUSTOM BUTTON ACTION

*/
/* Retailer flyout button */
$(function() {
  var $retailerButton = $('a.button.retailers');

  if ( $retailerButton.length > 0 ) {
    $retailerButton.click(function(e){
      e.preventDefault();
      $(this).toggleClass('clicked');
      $('.retailer-list').fadeToggle(300);
    });
  }
});

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
    $viewHeight = $(window).outerHeight() - $('#footer nav').outerHeight();
    checkListMargin();
  });
  $viewWidth = $(window).width()
  $viewHeight = $(window).height() - $('#footer nav').outerHeight();
  $listHeight = $('#the-list').outerHeight();
  checkListMargin();
});
// the basic logic:
//    • if the window is taller than the list, center the list vertically
//    • if the window is shorter than the list, do not center
function checkListMargin() {
  var topMargin = $viewHeight/2 - $listHeight/2;
  if ($viewHeight > $listHeight && $viewWidth > 520) {
    $('#the-list').css('margin-top', topMargin);
  } else {
    $('#the-list').css('margin-top', '0px');
  }
}