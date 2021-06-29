defmodule InstaLive.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :photos_url, {:array, :string}

      timestamps()
    end

  end
end
