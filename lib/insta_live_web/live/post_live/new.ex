defmodule InstaLiveWeb.PostLive.New do
  use InstaLiveWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
      hi
    """
  end
end
