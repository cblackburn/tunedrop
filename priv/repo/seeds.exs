# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Tunedrop.Repo.insert!(%Tunedrop.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Tunedrop.Repo
alias Tunedrop.User

changeset = User.registration_changeset(
  %User{},
  %{email: "user1@example.com", username: "thedad", password: "asdfasdf"}
)
Repo.insert!(changeset)

changeset = User.registration_changeset(
  %User{},
  %{email: "user2@example.com", username: "brittany", password: "asdfasdf"}
)
Repo.insert!(changeset)
