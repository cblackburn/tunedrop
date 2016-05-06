defmodule Tunedrop.TuneView do
  use Tunedrop.Web, :view

  alias Phoenix.HTML.Tag
  alias Phoenix.HTML.Link

  def tune_link(conn, tune) do
    Tag.content_tag(:li, class: "track-item", id: "track-#{tune.id}") do
      [
        content_tag(:ul, class: "track-detail") do
          [
            track_user(tune),
            track_info(tune),
            content_tag(:span, class: "track-box track-icon-block") do
              [
                Tunedrop.TuneView.youtube_icon_for(tune),
                Tunedrop.TuneView.amazon_icon_for(tune),
                Tunedrop.TuneView.spotify_icon_for(conn, tune)
              ]
            end
          ]
        end
      ]
    end
  end

  def tune_details(_conn, tune) do
    %{
      id: tune.id,
      artist: tune.artist,
      track: tune.track,
      year: tune.year,
      listend_at: tune.inserted_at
    }
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
    artist = ControllerHelpers.encode_string(artist)
    track = ControllerHelpers.encode_string(track)
    "https://www.youtube.com/results?search_query=#{artist}+#{track}"
  end

  def amazon_url(%{artist: artist, track: track}) do
    #"http://www.amazon.com/gp/search?ie=UTF8&camp=1789&creative=9325&index=aps&keywords=tony+robbins&linkCode=ur2&tag=YOUR-ID-20"
    artist = ControllerHelpers.encode_string(artist)
    track = ControllerHelpers.encode_string(track)
    "http://www.amazon.com/s/ref=as_li_ss_tl?url=search-alias%3Daps&field-keywords=#{artist}+-+#{track}&rh=i%3Aaps%2Ck%3A#{artist}+-+#{track}&linkCode=ll2&tag=midwirtechno-20"
  end

  # private

  defp track_user(tune) do
    initial = tune.user.username |> String.at(0)
    title = "#{tune.user.username} - #{TimeAgoWords.diff(tune.inserted_at)} ago"
    content_tag(:li, class: "track-box track-user", title: title) do
      [
        content_tag(:span, class: "initials") do
          initial
        end
      ]
    end
  end

  defp track_info(tune) do
    Tag.content_tag(:li, class: "track-box track-info") do
      [
        tune.artist,
        Tag.tag(:br),
        track_tag(tune),
        " - #{tune.year}"
      ]
    end
  end

  defp track_tag(tune) do
    content_tag(:span, class: "track-name", data_item: "#{tune.id}", title: "click to play video") do
      tune.track
    end
  end
end
