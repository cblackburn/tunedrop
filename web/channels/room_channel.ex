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
    push(socket, "new_tune", payload)
    {:noreply, socket}
  end

  def broadcast_new_tune(conn, song) do
    payload = %{
      "content" => Tunedrop.TuneView.tune_link(conn, song) |> Phoenix.HTML.safe_to_string,
      "song" => Tunedrop.TuneView.tune_details(conn, song)
    }
    Tunedrop.Endpoint.broadcast!("rooms:lobby", "new_tune", payload)
    conn
  end
end
