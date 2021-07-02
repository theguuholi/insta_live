defmodule InstaLiveWeb.PageLive do
  use InstaLiveWeb, :live_view
  alias InstaLive.Posts

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(page: 1, per_page: 2)
      |> load_posts()

    {:ok, socket, temporary_assigns: [posts: []]}
  end

  def load_posts(socket) do
    assign(socket,
      posts: Posts.list_posts(page: socket.assigns.page, per_page: socket.assigns.per_page)
    )
  end

  @impl true
  def handle_event("load-posts", params, socket) do
    IO.inspect params
    socket = socket |> update(:page, &(&1 + 1)) |> load_posts()
    {:noreply, socket}
  end
end
