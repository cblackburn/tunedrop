defmodule Tunedrop.PageControllerTest do
  use Tunedrop.ConnCase

  test "shows welcome page", %{conn: conn} do
    conn = get(conn, page_path(conn, :index))
    assert html_response(conn, 200) =~ "Welcome to Tunedrop"
  end
end
