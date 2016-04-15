defmodule Tunedrop.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :username, :string, null: false
      add :password_hash, :string
      add :api_token, :string

      timestamps
    end

    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
    create unique_index(:users, [:api_token])
  end
end
