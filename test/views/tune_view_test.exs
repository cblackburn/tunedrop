require IEx
defmodule Tunedrop.TuneViewTest do
  use Tunedrop.ConnCase, async: true
  use Timex

  setup %{conn: conn} do
    {:ok, conn: conn}
  end

  test "returns icon tags", %{conn: conn} do
    user = %Tunedrop.User{username: "iamtheuser"}
    song = %Tunedrop.Song{
      id: 111,
      artist: "ELO",
      track: "Strange Magic",
      year: 1975,
      user: user,
      inserted_at: DateTime.now
    }
    conn = get conn, song_path(conn, :index)
    content = Tunedrop.TuneView.tune_link(conn, song) |> Phoenix.HTML.safe_to_string
    assert content =~ ~r/amazon\.com/
    assert content =~ ~r/youtube\.com/
    assert content =~ ~r/spotify\/#{song.id}/
    assert content =~ ~r/yt\.png/
    assert content =~ ~r/az\.png/
    assert content =~ ~r/sp\.png/
  end

  test "escapes artist for amazon url" do
    data = %{artist: "Earth, Wind & Fire", track: "Baby It's You"}
    content = Tunedrop.TuneView.amazon_url(data)
    assert content =~ ~r/Earth,%20Wind%20%26%20Fire/
    assert content =~ ~r/amazon\.com/
  end

  test "escapes artist for youtube url" do
    data = %{artist: "Earth, Wind & Fire", track: "Baby It's You"}
    content = Tunedrop.TuneView.youtube_url(data)
    assert content =~ ~r/Earth,%20Wind%20%26%20Fire/
    assert content =~ ~r/youtube\.com/
  end
end
