function hideVideo() {
  $("iframe#video").hide();
  $(".show-video-link").show();
  $(".hide-video-link").hide();
}

function showVideo() {
  $("iframe#video").show();
  $(".hide-video-link").show();
  $(".show-video-link").hide();
}

$(".show-video-link").click(function(e) {
  e.preventDefault();
  showVideo();
});

$(".hide-video-link").click(function(e) {
  e.preventDefault();
  hideVideo();
});

$( document ).ready(function() {
  var playerFrame = $("iframe#video");
  if (playerFrame.attr("src") == null) {
    hideVideo();
  } else {
    showVideo();
  }
});
