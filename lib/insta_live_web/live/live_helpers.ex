defmodule InstaLiveWeb.LiveHelpers do
  import Phoenix.LiveView
  alias InstaLive.Accounts

  def assign_current_user(socket, %{"user_token" => user_token}) do
    current_user = Accounts.get_user_by_session_token(user_token)
    assign_new(socket, :current_user, fn -> current_user end)
  end
end
