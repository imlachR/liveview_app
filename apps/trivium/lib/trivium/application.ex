defmodule Trivium.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Trivium.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Trivium.PubSub}
      # Start a worker by calling: Trivium.Worker.start_link(arg)
      # {Trivium.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Trivium.Supervisor)
  end
end
