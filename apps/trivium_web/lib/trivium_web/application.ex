defmodule TriviumWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      TriviumWeb.Telemetry,
      TriviumWeb.Presence,
      # Start the Endpoint (http/https)
      TriviumWeb.Endpoint
      # Start a worker by calling: TriviumWeb.Worker.start_link(arg)
      # {TriviumWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TriviumWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TriviumWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
