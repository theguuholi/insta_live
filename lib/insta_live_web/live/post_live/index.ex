defmodule InstaLiveWeb.PostLive.Index do
  use InstaLiveWeb, :live_view
  alias Phoenix.View
  alias InstaLiveWeb.PostView
  alias InstaLive.Posts

  @impl true
  def mount(_params, session, socket) do
    socket = assign_current_user(socket, session)
    user_id = socket.assigns.current_user.id
    if connected?(socket), do: Posts.subscribe(user_id)
    params = [posts: Posts.list_posts(user_id)]
    socket = assign(socket, params)
    {:ok, socket, temporary_assigns: [posts: []]}
  end

  @impl true
  def render(assigns) do
    View.render(PostView, "index.html", assigns)
  end

  @impl true
  def handle_info({:insert_post, post}, socket) do
    {:noreply, update(socket, :posts, &[post | &1])}
  end
end
