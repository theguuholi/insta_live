defmodule InstaLiveWeb.PostLive.New do
  use InstaLiveWeb, :live_view
  alias Phoenix.View
  alias InstaLiveWeb.PostView

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    View.render(PostView, "new.html", assigns)
  end
end
