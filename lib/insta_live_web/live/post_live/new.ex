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
  def handle_event("validate", params, socket) do
    IO.inspect("validate")
    IO.inspect(params)
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", params, socket) do
    urls = store_posts_and_get_url(socket)
    params = Map.put(params, "photos_url", urls)

    case Posts.create_post(params) do
      {:ok, _post} ->
        socket = socket
        |> put_flash(:info, "Post has been created!")
        |> assign(changeset: Posts.change_post())
        IO.inspect "sss!!"

        {:noreply, socket}

      {:error, changeset} ->
        IO.inspect "here!!"
        IO.inspect changeset
        socket =
          socket
          |> put_flash(:error, "invalid payload")
          |> assign(changeset: changeset)

        {:noreply, socket}
    end

    IO.inspect(params)
    {:noreply, socket}
  end

  defp store_posts_and_get_url(socket) do
    consume_uploaded_entries(socket, :posts, fn meta, entry ->
      # IO.inspect meta, label: "meta"
      # IO.inspect entry, label: "entry"
      dest = Path.join("priv/static/uploads", filename(entry))
      File.cp!(meta.path, dest)
      Routes.static_path(socket, "/uploads/#{filename(entry)}")
    end)
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
