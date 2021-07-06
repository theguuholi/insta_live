defmodule InstaLiveWeb.UserLive.FollowComponent do
  use InstaLiveWeb, :live_component

  @impl true
  def update(assigns, socket) do
    #components  1 agrupar codigo junto e facil de ler e manter, 2 indepentende pode usar em outras paginas
    # live: pai e os componentes sao criancas
    # send self
    # stateless:  e apenas lidar com os dados o pai e responsavel, nao lida com eventos
    # statefull:
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(InstaLiveWeb.UserView, "follow.html", assigns)
  end
end
