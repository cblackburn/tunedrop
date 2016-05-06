defmodule ControllerHelpers do
  def encode_string(string) do
    string
    |> String.replace(" ", "%20")
    |> String.replace("&", "%26")
    |> String.replace("’", "'")
    |> String.replace("‐", "%2D")
    |> String.replace("/", "%2F")
  end
end
