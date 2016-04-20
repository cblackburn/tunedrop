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
    |> assoc_constraint(:user)
  end

  def with_user(song) do
    Repo.preload(song, :user)
  end

  def duplicate_post(changeset, user_id) do
    Song
    |> where([s], s.inserted_at > datetime_add(^Ecto.DateTime.utc, -5, "minute"))
    |> where([s], s.artist == ^get_field(changeset, :artist))
    |> where([s], s.track == ^get_field(changeset, :track))
    |> where([s], s.year == ^get_field(changeset, :year))
    |> where([s], s.user_id == ^user_id)
    |> order_by([s], desc: s.inserted_at)
    |> limit(1)
    |> Repo.one()
  end

  # defp validate_not_duplicate(changeset, %{user_id: user_id}) do
  #   case duplicate_post(changeset, user_id) do
  #     nil -> changeset
  #     _ -> add_error(changeset, :song, "You already posted that")
  #   end
  # end
  # defp validate_not_duplicate(changeset, %{}) do
  #   add_error(changeset, :user_id, "Cannot be nil")
  # end
end
