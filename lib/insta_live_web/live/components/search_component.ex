defmodule InstaLiveWeb.Components.SearchComponent do
  use InstaLiveWeb, :live_component
  alias InstaLive.Accounts

  @impl true
  def mount(socket) do
    {:ok, assign(socket, users_matches: [])}
  end

  @impl true
  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def render(assigns) do
    Phoenix.View.render(InstaLiveWeb.ComponentView, "search_component.html", assigns)
  end

  def search_user(socket, search) do
    users_matches =
      if search == "" or search == nil do
        []
      else
        current_user_id = socket.assigns.current_user.id
        Accounts.list_users(search, current_user_id)
      end

    assign(socket, users_matches: users_matches)
  end

  @impl true
  def handle_event("search-users", %{"search" => search}, socket) do
    {:noreply, search_user(socket, search)}
  end
end
