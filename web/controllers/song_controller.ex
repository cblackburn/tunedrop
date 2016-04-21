defmodule Tunedrop.SongController do
  use Tunedrop.Web, :controller

  alias Tunedrop.Song

  plug :scrub_params, "song" when action in [:create, :update]

  def action(conn, _) do
    apply(
      __MODULE__,
      action_name(conn),
      [conn, conn.params, conn.assigns.current_user]
    )
  end

  def index(conn, _params, user) do
    songs = Song |> Repo.all |> Repo.preload(:user)
    render(conn, "index.json", songs: songs)
  end

  def create(conn, %{"song" => song_params}, user) do
    changeset =
      user
      |> build_assoc(:songs)
      |> Song.changeset(Map.put(song_params, "user_id", user.id))

    case Repo.insert(changeset) do
      {:ok, song} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", song_path(conn, :show, song))
        |> Tunedrop.RoomChannel.broadcast_new_tune(Repo.preload(song, :user))
        |> render("show.json", song: song)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Tunedrop.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    song = Repo.get!(Song, id)
    render(conn, "show.json", song: song)
  end
end
