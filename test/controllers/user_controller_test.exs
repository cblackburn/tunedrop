require IEx
defmodule Tunedrop.UserControllerTest do
  use Tunedrop.ConnCase
  alias Tunedrop.User

  @valid_attrs %{email: "user1@example.com", username: "boogadie", password: "asdfasdf"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  test "renders the new user form", %{conn: conn} do
    conn = get(conn, user_path(conn, :new))
    assert html_response(conn, 200) =~ "New User"
  end

  test "shows list of users", %{conn: conn} do
    user = insert_user(@valid_attrs)
    conn = login_user(conn, user)
    conn = get(conn, user_path(conn, :index))
    assert html_response(conn, 200) =~ user.username
  end

  test "creates and renders resource when params are valid", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @valid_attrs)
    assert redirected_to(conn) =~ user_path(conn, :index)
    assert get_flash(conn, :info) =~ "created"
    assert Repo.get_by(User, email: "user1@example.com")
  end

  test "does not create resource and renders erros when params are invalid", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "errors below"
    refute Repo.get_by(User, email: "user1@example.com")
  end

  test "shows the specified user", %{conn: conn} do
    user = insert_user(@valid_attrs)
    conn = login_user(conn, user)
    conn = get(conn, user_path(conn, :show, user))
    assert html_response(conn, 200) =~ user.username
  end

  defp login_user(conn, user) do
    post(
      conn, session_path(conn, :create),
      session: %{username: user.username, password: user.password}
    )
  end
end
