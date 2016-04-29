require IEx
defmodule Tunedrop.YoutubeControllerTest do
  use Tunedrop.ConnCase
  alias Tunedrop.Song

  @song_attrs %{artist: "Pilot", track: "Magic", year: 1967}

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  test ":show returns a single video URL for the passed song", %{conn: conn} do
    user = insert_user()
    song = insert_song(user, @song_attrs)
    conn = get(conn, youtube_path(conn, :show, song))
    url = json_response(conn, 200)["data"]
    assert url =~ ~r"https://www.youtube.com/embed/\w+"
  end
end
