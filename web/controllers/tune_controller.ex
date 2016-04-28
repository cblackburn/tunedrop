defmodule Tunedrop.TuneController do
  use Tunedrop.Web, :controller

  alias Tunedrop.Song

  def index(conn, _params) do
    tunes = Repo.all(
      from s in Song,
      limit: 100,
      order_by: [desc: s.inserted_at],
      preload: [:user]
    )
    render conn, "index.html", tunes: tunes
  end
end
