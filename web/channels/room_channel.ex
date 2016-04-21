defmodule Tunedrop.RoomChannel do
  use Phoenix.Channel
  use Timex

  def join("rooms:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("rooms:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_out("new_tune", payload, socket) do
    push socket, "new_tune", payload
    {:noreply, socket}
  end

  def broadcast_new_tune(conn, song) do
    payload = %{
      "username" => song.user.username,
      "artist" => song.artist,
      "track" => song.track,
      "year" => song.year,
      "inserted_at" => javascript_datetime(song.inserted_at)
    }
    Tunedrop.Endpoint.broadcast!("rooms:lobby", "new_tune", payload)
    conn
  end

  defp javascript_datetime(datetime) do
    Timex.Format.DateTime.Formatter.format!(datetime, "%m/%d %H:%M", :strftime)
  end
end
