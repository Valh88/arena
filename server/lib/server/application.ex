defmodule Server.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Server.Game.GameGenServer
  alias Server.RegistryService
  alias Server.ClientSocketDynamicSupervisor

  use Application

  @impl true
  def start(_type, _args) do
    RegistryService.start_registry()

    children = [
      # Starts a worker by calling: Server.Worker.start_link(arg)
      # {Server.Worker, arg}
      {Server.TcpListener, 1235},
      {ClientSocketDynamicSupervisor, []},
      {GameGenServer, %{game_id: "game_id"}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
