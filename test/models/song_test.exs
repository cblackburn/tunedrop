defmodule Tunedrop.SongTest do
  use Tunedrop.ModelCase
  use Timex

  alias Tunedrop.Song

  @valid_attrs %{artist: "ELO", track: "Strange Magic", year: 1975, user_id: 1}
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

  test "with_user" do
    user = insert_user(username: "iamtheuser", password: "secret123")
    attrs = Map.put(@valid_attrs, :user_id, user.id)
    song = insert_song(user, attrs)
    song_with_user = Song.with_user(song)
    assert song_with_user.user.username
  end

  test "no duplicates" do
    user = insert_user(username: "iamtheuser", password: "secret123")
    attrs = Map.put(@valid_attrs, :user_id, user.id)
    insert_song(user, attrs)
    changeset = Song.changeset(%Song{}, attrs)
    assert {:song, "You already posted that"}
        in changeset.errors
  end

  test "duplicate_post within 5 minutes" do
    user = insert_user(username: "iamtheuser", password: "secret123")
    attrs = Map.put(@valid_attrs, :user_id, user.id)
    insert_song(user, attrs)
    changeset = Song.changeset(%Song{}, attrs)
    dup = Song.duplicate_post(attrs)
    assert dup
  end

  test "no duplicate_post after 5 minutes" do
    user = insert_user(username: "iamtheuser", password: "secret123")
    attrs = Map.put(@valid_attrs, :user_id, user.id)
    new_time = DateTime.now |> Timex.add(Time.to_timestamp(-6, :minutes))
    insert_song(user, Map.put_new(attrs, :inserted_at, new_time))
    dup = Song.duplicate_post(attrs)
    refute dup
  end
end
