function showRemainingChar() {
  var chars = 140 - jQuery('#micropost_content').val().length;
  jQuery('.remainingChar').text(chars + ' character(s) remaining') 
}

$(document).ready(function($) {
  showRemainingChar();
  $('#micropost_content').change(showRemainingChar);
  $('#micropost_content').keyup(showRemainingChar);
});