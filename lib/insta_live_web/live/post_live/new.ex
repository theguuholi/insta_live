defmodule InstaLiveWeb.PostLive.New do
  use InstaLiveWeb, :live_view
  alias Phoenix.View
  alias InstaLiveWeb.PostView

  alias InstaLive.Posts

  # @accept :any
  @accept ~w[.png .jpeg .jpg]
  @max_photos 3
  @max_file_size 10_000_000

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> load_params()
      |> load_upload_configs()

    {:ok, socket}
  end

  defp load_params(socket) do
    params = [changeset: Posts.change_post()]
    assign(socket, params)
  end

  defp load_upload_configs(socket) do
    allow_upload(
      socket,
      :posts,
      accept: @accept,
      max_entries: @max_photos,
      max_file_size: @max_file_size
    )
  end

  @impl true
  def render(assigns) do
    View.render(PostView, "new.html", assigns)
  end

  @impl true
  def handle_event("validate", _, socket) do
    IO.inspect("validate")
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", _, socket) do
    IO.inspect("save")
    {:noreply, socket}
  end
end
