defmodule InstaLive.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :description, :string
    field :photos_url, {:array, :string}

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:description, :photos_url])
    |> validate_required([:description, :photos_url])
  end
end
