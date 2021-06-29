defmodule InstaLive.Posts do
  import Ecto.Query, warn: false
  alias InstaLive.Repo

  alias InstaLive.Posts.Post

  def list_posts do
    Repo.all(Post)
  end

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(InstaLive.PubSub, "posts-#{user_id}")
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:insert_post)
  end

  defp broadcast({:error, _c} = error, _event), do: {:error, error}

  defp broadcast({:ok, post}, event) do
    Phoenix.PubSub.broadcast(InstaLive.PubSub, "posts-#{post.user_id}", {event, post})
    {:ok, post}
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
