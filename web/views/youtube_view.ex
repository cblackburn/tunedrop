defmodule Tunedrop.YoutubeView do
  use Tunedrop.Web, :view

  def render("show.json", %{youtube: url}) do
    %{data: url}
  end
end
