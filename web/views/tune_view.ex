defmodule Tunedrop.TuneView do
  use Tunedrop.Web, :view
  use Timex
  alias Tunedrop.Song

  def listened_at(%Song{inserted_at: inserted_at}) do
    Timex.Format.DateTime.Formatter.format!(inserted_at, "%m/%d %H:%M", :strftime)
  end
end
