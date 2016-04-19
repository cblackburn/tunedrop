defmodule Tunedrop.TuneController do
  use Tunedrop.Web, :controller

  alias Tunedrop.Song

  def index(conn, _params) do
    tunes = Repo.all from s in Song, preload: [:user]
    render conn, "index.html", tunes: tunes
  end
end
