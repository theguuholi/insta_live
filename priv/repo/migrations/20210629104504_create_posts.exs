defmodule InstaLive.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :photos_url, {:array, :string}
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      timestamps()
    end
  end
end
