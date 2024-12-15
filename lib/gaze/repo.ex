defmodule Gaze.Repo do
  use Ecto.Repo,
    otp_app: :gaze,
    adapter: Ecto.Adapters.Postgres
end
