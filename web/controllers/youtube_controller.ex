require IEx
defmodule Tunedrop.YoutubeController do
  use Tunedrop.Web, :controller
  alias Tunedrop.Song

  def show(conn, %{"id" => id}) do
    url = Repo.get!(Song, id)
    |> lookup_song_on_youtube()
    |> extract_song_url_from_youtube_response()
    render(conn, "show.json", youtube: url)
  end

  # private

  defp youtube_search_url(%{artist: artist, track: track, year: _year}) do
    "https://www.youtube.com/results" <>
      "?search_query=#{encode(artist)}" <>
      "+#{encode(track)}"
  end

  defp encode(string) do
    string
    |> String.replace(" ", "%20")
    |> String.replace("&", "%26")
    |> String.replace("’", "'")
  end

  defp lookup_song_on_youtube(song) do
    try do
      response = HTTPotion.get(youtube_search_url(song))
      response.body
    rescue
      e in HTTPotion.HTTPError ->
        IO.puts("Error: #{e.message}")
        nil
    end
  end

  @doc """
  Render a blank video if html is nil
  """
  defp extract_song_url_from_youtube_response(html = nil) do
    "https://www.youtube.com/embed/oZPHnVlXcm0"
  end
  @doc """
  Extract the first video found and return an embeddable url
  """
  defp extract_song_url_from_youtube_response(html = _) do
    [_, id] = html
      |> Floki.find("#results a")
      |> Floki.attribute("href")
      |> Enum.find(fn(x) -> x =~ "/watch" end)
      |> String.split("=")
    "https://www.youtube.com/embed/" <> id
  end
end
