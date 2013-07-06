function showRemainingCharForMicropost() {
  var chars = 140 - jQuery('#micropost_content').val().length;
  jQuery('.remainingCharForMicropost').text(chars + ' character(s) remaining') 
}

$(document).ready(function($) {
  showRemainingCharForMicropost();
  $('#micropost_content').change(showRemainingCharForMicropost);
  $('#micropost_content').keyup(showRemainingCharForMicropost);
});
