defmodule Tunedrop.UserHelpers do
  @moduledoc """
  Shared helpers for user related things.
  """

  use Phoenix.HTML

  alias Tunedrop.User

  def display_name(nil) do
    "unregistered"
  end
  def display_name(%User{username: name}) do
    name
  end
end
