defmodule StreamTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      StreamTestWeb.Telemetry,
      # Start the Ecto repository
      StreamTest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: StreamTest.PubSub},
      # Start Finch
      {Finch, name: StreamTest.Finch},
      # Start the Endpoint (http/https)
      StreamTestWeb.Endpoint
      # Start a worker by calling: StreamTest.Worker.start_link(arg)
      # {StreamTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StreamTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StreamTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
