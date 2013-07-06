function showRemainingCharForAlbum() {
  var chars = 40 - jQuery('#album_album_title').val().length;
  jQuery('.remainingCharForAlbum').text(chars + ' character(s) remaining') 
}

$(document).ready(function($) {
  showRemainingCharForAlbum();
  $('#album_album_title').change(showRemainingCharForAlbum);
  $('#album_album_title').keyup(showRemainingCharForAlbum);
});