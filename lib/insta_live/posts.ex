defmodule InstaLive.Posts do
  import Ecto.Query, warn: false
  alias InstaLive.Repo

  alias InstaLive.Posts.Post

  def list_posts(page: page, per_page: per_page) do
    Post
    |> offset(^((page - 1) * per_page))
    |> limit(^per_page)
    |> order_by([{:desc, :inserted_at}])
    |> preload(:user)
    |> Repo.all()
  end

  def list_posts(user_id) do
    Repo.all(Post, user_id: user_id)
  end

  def subscribe(user_id) do
    Phoenix.PubSub.subscribe(InstaLive.PubSub, "posts-#{user_id}")
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs, fun) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> after_save(fun)
    |> broadcast(:insert_post)
  end

  defp after_save({:ok, post}, fun) do
    {:ok, _post} = fun.(post)
  end

  defp after_save(error, _fun), do: error

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

  def change_post(attrs \\ %{}) do
    change_post(%Post{}, attrs)
  end

  def change_post(%Post{} = post, attrs) do
    Post.changeset(post, attrs)
  end
end
