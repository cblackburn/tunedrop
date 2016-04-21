require IEx
defmodule Tunedrop.TuneView do
  use Tunedrop.Web, :view
  use Timex

  alias Tunedrop.Song
  alias Phoenix.HTML.Tag
  alias Phoenix.HTML.Link

  def tune_link(tune) do
    Tag.content_tag(:li, class: "track-item") do
      [
        "@#{tune.user.username}" <> " ° " <>
        listened_at(tune) <> " » " <>
        tune.artist <> " · " <>
        tune.track <> " · " <>
        "#{tune.year} ",
        Tunedrop.TuneView.youtube_icon_for(tune),
        Tunedrop.TuneView.amazon_icon_for(tune)
      ]
    end
  end

  def listened_at(%Song{inserted_at: inserted_at}) do
    Timex.Format.DateTime.Formatter.format!(inserted_at, "%m/%d %H:%M", :strftime)
  end

  def youtube_icon_for(tune) do
    Link.link(to: youtube_url(tune), target: "_tunedrop") do
      Tag.tag(:img, class: "track-icon", src: "/images/yt.png")
    end
  end

  def amazon_icon_for(tune) do
    Link.link(to: amazon_url(tune), target: "_tunedrop") do
      Tag.tag(:img, class: "track-icon", src: "/images/az.png")
    end
  end

  defp youtube_url(%{artist: artist, track: track}) do
    artist = URI.encode(artist)
    track = URI.encode(track)
    "https://www.youtube.com/results?search_query=#{artist}+#{track}"
  end

  defp amazon_url(%{artist: artist, track: track}) do
    #"http://www.amazon.com/gp/search?ie=UTF8&camp=1789&creative=9325&index=aps&keywords=tony+robbins&linkCode=ur2&tag=YOUR-ID-20"
    artist = URI.encode(artist)
    track = URI.encode(track)
    "http://www.amazon.com/s/ref=as_li_ss_tl?url=search-alias%3Daps&field-keywords=#{artist}+-+#{track}&rh=i%3Aaps%2Ck%3A#{artist}+-+#{track}&linkCode=ll2&tag=midwirtechno-20"
  end
end
