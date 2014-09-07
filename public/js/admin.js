$(function() {
  $("#back-images-input ul").sortable();

  $("#cover-art-modal li").click(function() {
    $(this).addClass("selected").siblings().removeClass("selected");
  });

  $("#back-images-modal li").click(function() {
    $(this).toggleClass("selected");
  });
});

function setCoverArt() {
  cover_art = $('#cover-art-modal .selected img');

  $('#cover-art-input').attr('value', cover_art.attr('src'));
  $('#cover-art-display').html(cover_art.clone());
}

function initCoverArt() {

}

function setBackImages() {
  $('#back-images-input ul').empty()
  back_images = $('#back-images-modal .selected img');
  back_images.each(function(index) {
    input_elt = $('<input type="hidden" class="form-control" name="images[]">').attr('value',$(this).attr('src'));
    image_elt = $(this).clone();
    $('#back-images-input ul').append($('<li>').append(input_elt).append(image_elt));
  });
  $('#back-images-input ul').css('min-height', $('#back-images-input ul').height());
}

function initBackImages(image_urls) {
  for(var i in image_urls){
    input_elt = $('<input type="hidden" class="form-control" name="images[]">').attr('value',image_urls[i]);
    image_elt = $('<img src="' + image_urls[i] + '"">');
    $('#back-images-input ul').append($('<li>').append(input_elt).append(image_elt));
  }
  $('#back-images-input ul').css('min-height', $('#back-images-input ul').height());
}