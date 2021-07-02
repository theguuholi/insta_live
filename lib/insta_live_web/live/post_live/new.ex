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
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign_current_user(session)
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
  def handle_event("validate", %{"post" => post}, socket) do
    changeset =
      post
      |> Posts.change_post()
      |> Map.put(:action, :validate)

    {:noreply, socket |> assign(changeset: changeset)}
  end

  @impl true
  def handle_event("save", %{"post" => post}, socket) do
    {completed, []} = uploaded_entries(socket, :posts)
    urls = Enum.map(completed, &Routes.static_path(socket, "/uploads/#{filename(&1)}"))
    fetch_fields = %{"photos_url" => urls, "user_id" => socket.assigns.current_user.id}
    params = Map.merge(post, fetch_fields)
    case Posts.create_post(params, &store_posts(socket, &1)) do
      {:ok, _post} ->
        socket = put_flash(socket, :info, "Post has been created!")
        {:noreply, push_redirect(socket, to: "/posts")}
      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "invalid payload")
          |> assign(changeset: changeset)

        {:noreply, socket}
    end
  end

  defp store_posts(socket, post) do
    consume_uploaded_entries(socket, :posts, fn meta, entry ->
      # IO.inspect meta, label: "meta"
      # IO.inspect entry, label: "entry"
      dest = Path.join("priv/static/uploads", filename(entry))
      File.cp!(meta.path, dest)
    end)

    {:ok, post}
  end

  defp filename(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  @impl true
  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :posts, ref)}
  end
end
