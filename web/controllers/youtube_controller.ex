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
      "?search_query=#{ControllerHelpers.encode_string(artist)}" <>
      "+#{ControllerHelpers.encode_string(track)}"
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

  defp extract_song_url_from_youtube_response(_html = nil) do
    "https://www.youtube.com/embed/U-pyNeUDCQ4"
  end

  # TODO: Add weight to "live", "HD", "official", then most views
  defp extract_song_url_from_youtube_response(html = _) do
    [_, id] = html
    |> Floki.find("#results a")
    |> Floki.attribute("href")
    |> Enum.find(fn(x) -> x =~ "/watch" end)
    |> String.split("=")
    "https://www.youtube.com/embed/" <> id
  end

  # The number views is not the best criteria to chooose a video!
  # defp extract_song_url_from_youtube_response(html = _) do
  #   sorted = html
  #   |> Floki.find(".yt-lockup-content")
  #   |> Enum.sort(fn(item1, item2) -> view_count(item1) > view_count(item2) end)

  #   [_, id] = Enum.at(sorted, 0)
  #   |> Floki.find("h3 > a")
  #   |> Floki.attribute("href")
  #   |> Enum.find(fn(x) -> x =~ "/watch" end)
  #   |> String.split("=")
  #   "https://www.youtube.com/embed/" <> id
  # end

  # defp view_count(item) do
  #   meta = item |> Floki.find(".yt-lockup-meta-info > li")
  #   views = case Enum.at(meta, 1) do
  #     {"li", _, viewlist} ->
  #       parts = String.split(Enum.at(viewlist, 0), " ")
  #       String.to_integer(String.replace(Enum.at(parts, 0), ",", ""))
  #     nil ->
  #       # most likely a playlist
  #       0
  #   end
  # end
end
