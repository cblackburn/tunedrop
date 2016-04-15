defmodule Tunedrop.SongTest do
  use Tunedrop.ModelCase

  alias Tunedrop.Song

  @valid_attrs %{artist: "some content", track: "some content", url: "some content", year: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Song.changeset(%Song{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Song.changeset(%Song{}, @invalid_attrs)
    refute changeset.valid?
  end
end
