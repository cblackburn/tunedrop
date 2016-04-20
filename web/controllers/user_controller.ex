defmodule Tunedrop.UserController do
  use Tunedrop.Web, :controller
  alias Tunedrop.User

  plug :authenticate_user when action in [:index, :show]
  plug :scrub_params, "user" when action in [:create]

  def index(conn, _params) do
    users = Repo.all(Tunedrop.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user, conn: conn)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Tunedrop.Auth.login(user)
        |> put_flash(:info, "#{user.username} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, status: :unprocessable_entity)
    end
  end
end
