require IEx
defmodule Tunedrop.SessionControllerTest do
  use Tunedrop.ConnCase

  @valid_attrs %{username: "boogadie", password: "asdfasdf"}
  @invalid_attrs %{username: "wrong", password: "alsowrong"}

  setup %{conn: conn} do
    insert_user(@valid_attrs)
    {:ok, conn: conn}
  end

  test "shows the login form", %{conn: conn} do
    conn = get(conn, session_path(conn, :new))
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates a new user session for a valid user", %{conn: conn} do
    conn = post(conn, session_path(conn, :create), session: @valid_attrs)
    assert conn.assigns.current_user
    assert get_session(conn, :user_id)
    assert get_flash(conn, :info) =~ "Welcome"
    assert redirected_to(conn) =~ tune_path(conn, :index)
  end

  test "does not create a session with bad login info", %{conn: conn} do
    conn = post(conn, session_path(conn, :create), session: @invalid_attrs)
    refute conn.assigns.current_user
    refute get_session(conn, :user_id)
    assert get_flash(conn, :error) =~ "Invalid"
  end

  test "deletes the specified user session", %{conn: conn} do
    conn = post(conn, session_path(conn, :create), session: @valid_attrs)
    conn = delete(conn, session_path(conn, :delete, conn.assigns.current_user))
    assert get_flash(conn, :info) =~ "Logged out"
    assert redirected_to(conn) =~ tune_path(conn, :index)
  end
end
