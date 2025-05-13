defmodule TcpServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    TcpServer.RegistryService.start_registry()
    children = [
      # Starts a worker by calling: TcpServer.Worker.start_link(arg)
      # {TcpServer.Worker, arg}
      {TcpServer.TcpListener, 1235},
      {TcpServer.ClientSocketDynamicSupervisor, []},
      {Game.GameGenServer, %{game_id: "game_id"}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TcpServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
