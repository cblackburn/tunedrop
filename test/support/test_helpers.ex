defmodule Tunedrop.TestHelpers do
  alias Tunedrop.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      email: "user@example.com",
      username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
      password: "supersecret",
      }, attrs)

    %Tunedrop.User{}
    |> Tunedrop.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_song(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:songs, attrs)
    |> Repo.insert!()
    # |> Repo.preload([:user])
  end
end
