defmodule StreamTest.Repo do
  use Ecto.Repo,
    otp_app: :stream_test,
    adapter: Ecto.Adapters.Postgres
end
