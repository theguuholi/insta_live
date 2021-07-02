defmodule InstaLive.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias InstaLive.Accounts.User

  @required_fields ~w[description photos_url user_id]a
  @optional_fields ~w[]a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "posts" do
    field :description, :string
    field :photos_url, {:array, :string}
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(post, attrs \\ %{}) do
    post
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
