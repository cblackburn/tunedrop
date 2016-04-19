defmodule Tunedrop.SongTest do
  use Tunedrop.ModelCase
  use Timex

  alias Tunedrop.Song

  @valid_attrs %{artist: "ELO", track: "Strange Magic", year: "1975", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Song.changeset(%Song{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Song.changeset(%Song{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with year too early" do
    attrs = Map.put(@valid_attrs, :year, "1500")
    changeset = Song.changeset(%Song{}, attrs)
    assert {:year, {"must be greater than %{count}", [count: 1800]}}
        in changeset.errors
  end

  test "changeset with year too late" do
    year = Date.today.year + 1
    attrs = Map.put(@valid_attrs, :year, "2100")
    changeset = Song.changeset(%Song{}, attrs)
    assert {:year, {"must be less than %{count}", [count: year]}}
        in changeset.errors
  end
end
