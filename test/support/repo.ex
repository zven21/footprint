defmodule Footprint.Repo do
  use Ecto.Repo, otp_app: :footprint, adapter: Ecto.Adapters.Postgres
end
