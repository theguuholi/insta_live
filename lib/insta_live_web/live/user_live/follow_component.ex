defmodule InstaLiveWeb.UserLive.FollowComponent do
  use InstaLiveWeb, :live_component
  alias InstaLive.Accounts

  @impl true
  def update(assigns, socket) do
    # components  1 agrupar codigo junto e facil de ler e manter, 2 indepentende pode usar em outras paginas
    # live: pai e os componentes sao criancas
    # send self
    # stateless:  e apenas lidar com os dados o pai e responsavel, nao lida com eventos
    # statefull:

    socket =
      socket
      |> assign(assigns)
      |> following?()

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(InstaLiveWeb.UserView, "follow.html", assigns)
  end

  def following?(socket) do
    current_user_id = socket.assigns.current_user.id
    user_id = socket.assigns.user.id

    assign_params =
      if Accounts.following?(current_user_id, user_id) do
        [btn_follow: "remove", color_btn_follow: "red"]
      else
        [btn_follow: "add", color_btn_follow: "blue"]
      end

    assign(socket, assign_params)
  end

  def create_follow(current_user, user_to_follow) do
    Accounts.create_follow(current_user, user_to_follow)
  end

  @impl true
  def handle_event("toggle-status", _params, socket) do
    current_user = socket.assigns.current_user
    user = socket.assigns.user

    socket =
      case create_follow(current_user, user) do
        {:ok, _folow_info} -> following?(socket)
        {:error, _} -> socket
      end

    {:noreply, socket}
  end
end
