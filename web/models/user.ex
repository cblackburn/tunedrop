defmodule Tunedrop.User do
  use Tunedrop.Web, :model

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :api_token, :string
    has_many :songs, Tunedrop.Song

    timestamps
  end

  @required_fields ~w(username email)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:username, min: 5, max: 20)
    |> validate_length(:email, min: 6, max: 255)
    |> validate_format(:email, ~r/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end

  @doc """
  password is required on create (registration)
  """
  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 8)
    |> put_api_token()
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end

  defp put_api_token(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :api_token, SecureRandom.urlsafe_base64())
      _ ->
        changeset
    end
  end
end
