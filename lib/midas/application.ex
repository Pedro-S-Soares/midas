defmodule Midas.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MidasWeb.Telemetry,
      Midas.Repo,
      {DNSCluster, query: Application.get_env(:midas, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Midas.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Midas.Finch},
      # Start a worker by calling: Midas.Worker.start_link(arg)
      # {Midas.Worker, arg},
      # Start to serve requests, typically the last entry
      MidasWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Midas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MidasWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
