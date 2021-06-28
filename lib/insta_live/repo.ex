defmodule InstaLive.Repo do
  use Ecto.Repo,
    otp_app: :insta_live,
    adapter: Ecto.Adapters.Postgres
end
