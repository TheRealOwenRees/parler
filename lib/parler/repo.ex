defmodule Parler.Repo do
  use Ecto.Repo,
    otp_app: :parler,
    adapter: Ecto.Adapters.Postgres
end
