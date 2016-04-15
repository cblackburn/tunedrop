defmodule Tunedrop.UserView do
  use Tunedrop.Web, :view
  alias Tunedrop.User

  def first_name(%User{username: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
