defmodule Tunedrop.SongView do
  use Tunedrop.Web, :view

  def render("index.json", %{songs: songs}) do
    %{data: render_many(songs, Tunedrop.SongView, "song.json")}
  end

  def render("show.json", %{song: song}) do
    %{data: render_one(song, Tunedrop.SongView, "song.json")}
  end

  def render("song.json", %{song: song}) do
    %{id: song.id,
      user_id: song.user_id,
      url: song.url,
      artist: song.artist,
      track: song.track,
      year: song.year}
  end
end
