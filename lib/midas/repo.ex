defmodule Midas.Repo do
  use Ecto.Repo,
    otp_app: :midas,
    adapter: Ecto.Adapters.Postgres
end
