defmodule Tunedrop.ApiAuth do
  import Plug.Conn
  import Phoenix.Controller

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    api_key = case List.keyfind(conn.req_headers, "x-api-key", 0) do
      {"x-api-key", the_key} -> the_key
      _ -> nil
    end

    cond do
      user = conn.assigns[:current_user] ->
        conn
      user = api_key && repo.get_by(Tunedrop.User, api_token: api_key) ->
        assign(conn, :current_user, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_api(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> render(Tunedrop.ErrorView, "error.json")
      |> halt()
    end
  end
end
