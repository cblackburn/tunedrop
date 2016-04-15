defmodule Tunedrop.PageController do
  use Tunedrop.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
