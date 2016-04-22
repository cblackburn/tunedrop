defmodule Tunedrop.Song do
  use Tunedrop.Web, :model
  use Timex

  import Ecto.Query

  alias Tunedrop.Repo
  alias Tunedrop.Song

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
    |> validate_number(:year, greater_than: 1800)
    |> validate_number(:year, less_than: Date.today.year + 1)
    |> validate_unique(params)
    |> assoc_constraint(:user)
  end

  def with_user(song) do
    Repo.preload(song, :user)
  end

  def validate_unique(changeset, params = %{artist: _artist, track: _track, year: _year, user_id: _user_id}) do
    case duplicate_post(params) do
      nil -> changeset
      _ -> add_error(changeset, :song, "You already posted that")
    end
  end
  def validate_unique(changeset, %{"artist" => artist, "track" => track, "year" => year, "user_id" => user_id}) do
    validate_unique(changeset, %{artist: artist, track: track, year: year, user_id: user_id})
  end
  def validate_unique(changeset, _params) do
    changeset
  end

  def duplicate_post(%{artist: artist, track: track, year: year, user_id: user_id}) do
    Song
    |> where([s], s.inserted_at > datetime_add(^Ecto.DateTime.utc, -10, "minute"))
    |> where([s], s.artist == ^artist)
    |> where([s], s.track == ^track)
    |> where([s], s.year == ^year)
    |> where([s], s.user_id == ^user_id)
    |> order_by([s], desc: s.inserted_at)
    |> limit(1)
    |> Repo.one()
  end
  def duplicate_post(%{"artist" => artist, "track" => track, "year" => year, "user_id" => user_id}) do
    duplicate_post(%{artist: artist, track: track, year: year, user_id: user_id})
  end
end
