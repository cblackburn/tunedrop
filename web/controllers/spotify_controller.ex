defmodule Tunedrop.SpotifyController do
  require Logger
  use Tunedrop.Web, :controller
  alias Tunedrop.Song

  def show(conn, %{"id" => id}) do
    url = Repo.get!(Song, id)
    |> lookup_song_on_spotify()
    |> extract_song_url_from_spotify_response()
    redirect(conn, external: url)
  end

  defp spotify_url(%{artist: artist, track: track, year: _year}) do
    "https://api.spotify.com/v1/search" <>
      "?q=track:#{ControllerHelpers.encode_string(track)}%20artist:#{ControllerHelpers.encode_string(artist)}" <>
      "&type=track"
  end

  defp lookup_song_on_spotify(song) do
    response = HTTPotion.get(spotify_url(song))
    response.body
  end

  defp extract_song_url_from_spotify_response(json) do
    data = json |> Poison.decode!
    album = Enum.at(data["tracks"]["items"], 0)
    album["external_urls"]["spotify"]
  end
end
