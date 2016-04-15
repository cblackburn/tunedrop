defmodule Tunedrop.Song do
  use Tunedrop.Web, :model

  schema "songs" do
    field :url, :string
    field :artist, :string
    field :track, :string
    field :year, :integer
    belongs_to :user, Tunedrop.User

    timestamps
  end

  @required_fields ~w(artist track year)
  @optional_fields ~w(url)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
