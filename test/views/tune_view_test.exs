require IEx
defmodule Tunedrop.TuneViewTest do
  use Tunedrop.ConnCase, async: true
  use Timex

  test "returns icon tags" do
    user = %Tunedrop.User{username: "iamtheuser"}
    song = %Tunedrop.Song{artist: "ELO", track: "Strange Magic", year: 1975, user: user, inserted_at: DateTime.now}
    content = Tunedrop.TuneView.tune_link(song) |> Phoenix.HTML.safe_to_string
    assert content =~ ~r/amazon\.com/
    assert content =~ ~r/youtube\.com/
    assert content =~ ~r/yt\.png/
    assert content =~ ~r/az\.png/
  end

  test "escapes artist for amazon url" do
    data = %{artist: "Earth, Wind & Fire", track: "Baby It's You"}
    content = Tunedrop.TuneView.amazon_url(data)
    assert content =~ ~r/Earth,\+Wind\+%26\+Fire/
    assert content =~ ~r/amazon\.com/
  end

  test "escapes artist for youtube url" do
    data = %{artist: "Earth, Wind & Fire", track: "Baby It's You"}
    content = Tunedrop.TuneView.youtube_url(data)
    assert content =~ ~r/Earth,\+Wind\+%26\+Fire/
    assert content =~ ~r/youtube\.com/
  end
end
