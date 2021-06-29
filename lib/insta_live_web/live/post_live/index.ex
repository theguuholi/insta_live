defmodule InstaLiveWeb.PostLive.Index do
  use InstaLiveWeb, :live_view
  alias Phoenix.View
  alias InstaLiveWeb.PostView
  alias InstaLive.Posts

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Posts.subscribe("user")
    params = [posts: Posts.list_posts()]
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
