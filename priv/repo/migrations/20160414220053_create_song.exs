defmodule Tunedrop.Repo.Migrations.CreateSong do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :url, :string
      add :artist, :string
      add :track, :string
      add :year, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:songs, [:user_id])
  end
end
