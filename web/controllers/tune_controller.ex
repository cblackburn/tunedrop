defmodule Tunedrop.TuneController do
  use Tunedrop.Web, :controller

  alias Tunedrop.Song

  def index(conn, _params) do
    # tunes = Repo.all()
    tunes = Repo.all(
      from s in Song,
      join: u in assoc(s, :user),
      select: {s, u}
    )
    IO.puts "#{inspect(tunes)}"
    render conn, "index.html", tunes: tunes
  end
end
