defmodule Tunedrop.UserHelpers do
  @moduledoc """
  Shared helpers for user related things.
  """

  alias Tunedrop.User

  use Phoenix.HTML

  def display_name(nil) do
    "unregistered"
  end
  def display_name(%User{username: name}) do
    name
  end
end
