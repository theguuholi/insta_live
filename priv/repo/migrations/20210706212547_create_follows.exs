defmodule InstaLive.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :follower_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :followed_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    alter table(:users) do
      add :followers_count, :integer, default: 0
      add :following_count, :integer, default: 0
    end

    create index(:follows, [:follower_id])
    create index(:follows, [:followed_id])
  end
end
