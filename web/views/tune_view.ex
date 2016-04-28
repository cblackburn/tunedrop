require IEx
defmodule Tunedrop.TuneView do
  use Tunedrop.Web, :view
  use Timex

  alias Tunedrop.Song
  alias Phoenix.HTML.Tag
  alias Phoenix.HTML.Link
  alias Tunedrop.TimeHelpers

  def tune_link(conn, tune) do
    Tag.content_tag(:li, class: "track-item") do
      [
        "@#{tune.user.username}" <> " ° ",
        time_ago(tune),
        " » " <>
        tune.artist <> " · " <>
        tune.track <> " · " <>
        "#{tune.year} ",
        Tunedrop.TuneView.youtube_icon_for(tune),
        Tunedrop.TuneView.amazon_icon_for(tune),
        Tunedrop.TuneView.spotify_icon_for(conn, tune)
      ]
    end
  end

  def listened_at(%Song{inserted_at: inserted_at}) do
    Timex.Format.DateTime.Formatter.format!(inserted_at, "%B %d @ %H:%M UTC", :strftime)
  end

  def time_ago(%Song{inserted_at: inserted_at}) do
    Tag.content_tag(:span, class: "time-ago", title: listened_at(%Song{inserted_at: inserted_at})) do
      TimeHelpers.distance_of_time_in_words(inserted_at) <> " ago"
    end
  end

  def youtube_icon_for(tune) do
    Link.link(to: youtube_url(tune), target: "_tunedrop", title: "Find on Youtube.") do
      Tag.tag(:img, class: "track-icon", src: "/images/yt.png")
    end
  end

  def amazon_icon_for(tune) do
    Link.link(to: amazon_url(tune), target: "_tunedrop", title: "Buy mp3 on Amazon.") do
      Tag.tag(:img, class: "track-icon", src: "/images/az.png")
    end
  end

  def spotify_icon_for(conn, tune) do
    Link.link(to: spotify_path(conn, :show, tune), target: "_tunedrop", title: "Listen on Spotify") do
      Tag.tag(:img, class: "track-icon", src: "/images/sp.png")
    end
  end

  def youtube_url(%{artist: artist, track: track}) do
    artist = encode(artist)
    track = encode(track)
    "https://www.youtube.com/results?search_query=#{artist}+#{track}"
  end

  def amazon_url(%{artist: artist, track: track}) do
    #"http://www.amazon.com/gp/search?ie=UTF8&camp=1789&creative=9325&index=aps&keywords=tony+robbins&linkCode=ur2&tag=YOUR-ID-20"
    artist = encode(artist)
    track = encode(track)
    "http://www.amazon.com/s/ref=as_li_ss_tl?url=search-alias%3Daps&field-keywords=#{artist}+-+#{track}&rh=i%3Aaps%2Ck%3A#{artist}+-+#{track}&linkCode=ll2&tag=midwirtechno-20"
  end

  defp encode(string) do
    string
    |> String.replace(" ", "+")
    |> String.replace("&", "%26")
  end
end
