defmodule Tunedrop.UserControllerTest do
  use Tunedrop.ConnCase
  alias Tunedrop.User

  @valid_attrs %{email: "user1@example.com", username: "boogadie", password: "asdfasdf"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when params are valid" do
    conn = post(conn, user_path(conn, :create), user: @valid_attrs)
    assert redirected_to(conn) =~ "/users"
    assert Repo.get_by(User, email: "user1@example.com")
  end

  test "does not create resource and renders erros when params are invalid" do
    conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "errors below"
    refute Repo.get_by(User, email: "user1@example.com")
  end
end
