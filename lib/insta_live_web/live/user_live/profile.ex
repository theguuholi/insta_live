defmodule InstaLiveWeb.UserLive.Profile do
  use InstaLiveWeb, :live_view
  alias InstaLive.Accounts

  @impl true
  def mount(%{"username" => username}, _session, socket) do
    socket = assign(socket, current_user: Accounts.get_user_by_username(username))
    IO.inspect socket.assigns.current_user
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(InstaLiveWeb.UserView, "profile.html", assigns)
  end
end
