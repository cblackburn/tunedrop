defmodule Tunedrop.PageControllerTest do
  use Tunedrop.ConnCase

  test "GET /welcome", %{conn: conn} do
    conn = get conn, "/welcome"
    assert html_response(conn, 200) =~ "Welcome to Tunedrop"
  end
end
