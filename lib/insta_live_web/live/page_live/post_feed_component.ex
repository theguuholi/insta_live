defmodule InstaLiveWeb.PageLive.PostFeedComponent do
  use InstaLiveWeb, :live_component

  def render(assigns) do
    Phoenix.View.render(InstaLiveWeb.PageView, "post_feed.html", assigns)
  end

end
