require IEx
defmodule Tunedrop.UserView do
  use Tunedrop.Web, :view
  alias Tunedrop.User

  def first_name(%User{username: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def display_token(conn, user) do
    case conn.assigns.current_user do
      ^user -> "(Your API token: #{user.api_token})"
      nil -> ""
      _ -> ""
    end
  end
end
