defmodule Tunedrop.UserTest do
  use Tunedrop.ModelCase

  alias Tunedrop.User

  @valid_attrs %{email: "user1@example.com", username: "boogadie", password: "asdfasdf"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset, email too short" do
    changeset = User.changeset(
      %User{}, Map.put(@valid_attrs, :email, "a@b.c")
    )
    refute changeset.valid?
  end

  test "changeset, email invalid format" do
    changeset = User.changeset(
      %User{}, Map.put(@valid_attrs, :email, "bogus.com")
    )
    refute changeset.valid?
  end

  test "registration_changeset, password is valid" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    assert changeset.changes.api_token
    assert changeset.changes.password_hash
    assert changeset.valid?
    {:ok, user} = Repo.insert(changeset)
    assert user.api_token
  end

  test "registration_changeset, password too short" do
    changeset = User.registration_changeset(
      %User{}, Map.put(@valid_attrs, :password, "1234567")
    )
    refute changeset.valid?
  end
end
