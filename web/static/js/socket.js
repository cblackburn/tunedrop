// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix";

let socket = new Socket("/socket", {
  params: {token: window.userToken},
  logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); }
});

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("rooms:lobby", {});
let tunesContainer = $("#tunes");
let loadingIndicator = $(".loading-indicator");
let playerFrame = $("iframe#video");
let playerState = null;
let player = null;

function scrollToDiv(id){
  $("html, body").animate({
    scrollTop: $("#currently-playing").offset().top
  }, "slow");
}

function bindTrackNames() {
  $(".track-name").click(function(event) {
    var song = {"id": $(this).attr("data-item")};
    playVideo(song, true);
  });
}

function findVideo(song) {
  var searchUrl = `/apihelper/youtube/${song.id}`;
  console.log(">>> findVideo: ", searchUrl);
  var videoUrl = null;
  $.ajax({
    url: searchUrl,
    type: "GET",
    async: false,
    dataType: "json",
    success: function(data, status, xhr) {
      videoUrl = data.data;
    },
    error: function(xhr, status, error) {
      console.log(">>> ERROR: ", xhr);
      console.log(">>> ERROR: ", status);
      console.log(">>> ERROR: ", error);
    }
  });
  return videoUrl;
}

function videoStateChanged(event) {
  console.log("videoStateChanged", event);
  playerState = event.data;
  if (playerState == YT.PlayerState.PLAYING) {
    hideLoading();
  }
}

function playVideo(song, force) {
  if (!force && playerState == YT.PlayerState.PLAYING) {
    return null;
  }

  showLoading();
  var videoSrc = findVideo(song) + "?autoplay=1&enablejsapi=1";
  if (playerFrame.attr("src") === videoSrc) {
    hideLoading();
    return null;
  }

  scrollToDiv("video-top");
  playerFrame.show();
  $(".hide-video-link").show();
  $(".show-video-link").hide();
  playerFrame.attr("src", videoSrc);

  player = new YT.Player("video", {
    events: {
      "onStateChange": videoStateChanged
    }
  });
}

// remove the video on page refresh
$(document).ready(function() {
  playerFrame.attr("src", "");
});

function fadeInTrack(track) {
  track.switchClass("track-item", "new-track-item", 1);
  track.switchClass("new-track-item", "track-item", 1000, "easeInOutCubic");
}

function showLoading() {
  loadingIndicator.show();
  setTimeout(hideLoading, 4000);
}

function hideLoading() {
  loadingIndicator.hide();
}

channel.on("new_tune", payload => {
  var tunes = $(".track-item");
  tunesContainer.prepend(`${payload.content}`);
  if (tunes.length > 99) {
    tunes.last().remove();
  }
  fadeInTrack($(`#track-${payload.song.id}`));
  bindTrackNames();
  playVideo(payload.song, false);
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp); })
  .receive("error", resp => { console.log("Unable to join", resp); });

export default socket;
bindTrackNames();
