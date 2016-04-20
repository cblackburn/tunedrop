defmodule Tunedrop.UserView do
  use Tunedrop.Web, :view
  import Tunedrop.UserHelpers

  def display_token(conn, user) do
    case conn.assigns.current_user do
      ^user -> "(Your API token: #{user.api_token})"
      nil -> ""
      _ -> ""
    end
  end
end
