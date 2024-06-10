defmodule LabsEasy.Repo do
  use Ecto.Repo,
    otp_app: :labs_easy,
    adapter: Ecto.Adapters.Postgres
end
