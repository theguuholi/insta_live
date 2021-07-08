defmodule InstaLiveWeb.PageLive do
  use InstaLiveWeb, :live_view
  alias InstaLive.Posts
  alias InstaLive.Accounts

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: 2)
      |> load_posts()
      |> load_users()
      |> assign_current_user(session)

    {:ok, socket, temporary_assigns: [posts: []]}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(InstaLiveWeb.PageView, "index.html", assigns)
  end

  def load_posts(socket) do
    assign(socket,
      posts: Posts.list_posts(page: socket.assigns.page, per_page: socket.assigns.per_page)
    )
  end

  def load_users(socket) do
    assign(socket,
      users: Accounts.list_users()
    )
  end

  @impl true
  def handle_event("load-posts", params, socket) do
    IO.inspect(params)
    socket = socket |> update(:page, &(&1 + 1)) |> load_posts()
    {:noreply, socket}
  end
end
