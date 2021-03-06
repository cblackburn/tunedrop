defmodule Tunedrop.SongControllerTest do
  use Tunedrop.ConnCase
  alias Tunedrop.Song
  alias Tunedrop.User

  @valid_attrs %{artist: "Pilot", track: "Magic", year: 1967}
  @invalid_attrs %{track: "bogus"}

  setup %{conn: conn} do
    user = insert_user(username: "iamtheuser", password: "secret123")
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    {:ok, conn: put_req_header(conn, "x-api-key", user.api_token)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, song_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    song = Repo.insert! %Song{}
    conn = get conn, song_path(conn, :show, song)
    assert json_response(conn, 200)["data"] == %{"id" => song.id,
      "user_id" => song.user_id,
      "url" => song.url,
      "artist" => song.artist,
      "track" => song.track,
      "year" => song.year}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, song_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, song_path(conn, :create), song: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Song, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, song_path(conn, :create), song: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "does not create resource and renders errors when duplicate", %{conn: conn} do
    user = Repo.get_by(User, username: "iamtheuser")
    attrs = Map.put(@valid_attrs, :user_id, user.id)
    insert_song(user, attrs)
    conn = post conn, song_path(conn, :create), song: @valid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "auth", %{conn: conn} do
    conn = delete_req_header(conn, "x-api-key")
    conn = post(conn, song_path(conn, :create), song: @valid_attrs)
    assert json_response(conn, 401) != %{}
  end
end
