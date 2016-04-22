defmodule Tunedrop.SpotifyControllerTest do
  use Tunedrop.ConnCase
  alias Tunedrop.Song

  @song_attrs %{artist: "Pilot", track: "Magic", year: 1967}

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  test ":show redirects to the proper spotify URL", %{conn: conn} do
    user = insert_user()
    song = insert_song(user, @song_attrs)
    conn = get(conn, spotify_path(conn, :show, song))
    assert redirected_to(conn, 302) =~ "spotify"
  end
end
