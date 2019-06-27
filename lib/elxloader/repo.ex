defmodule Elxloader.Repo do
  use Ecto.Repo,
    otp_app: :elxloader,
    adapter: Ecto.Adapters.Postgres
end
