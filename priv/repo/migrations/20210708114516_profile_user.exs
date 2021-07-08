defmodule InstaLive.Repo.Migrations.ProfileUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
      add :full_name, :string
      add :avatar_url, :string
      add :bio, :string
      add :website, :string
      add :posts_count, :integer, default: 0
    end

    create unique_index(:users, [:username])
  end
end
