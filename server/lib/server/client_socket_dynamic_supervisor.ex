defmodule Server.ClientSocketDynamicSupervisor do
  @moduledoc false
  use DynamicSupervisor

  alias Server.Game.PlayerGenServer
  alias Server.ClientSocketGenserver

  def start_link(_) do
    IO.puts("start  dynamic supervisor")
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_child(socket) do
    spec = %{
      id: ClientSocketGenserver,
      start: {ClientSocketGenserver, :start_link, [%{socket: socket}]},
      restart: :temporary
    }

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} -> {:ok, pid}
      error -> error
    end
  end

  def start_child_player_state(player_id, pid_user_socket) do
    spec = %{
      id: PlayerGenServer,
      start:
        {PlayerGenServer, :start_link, [%{user_id: player_id, pid_user_socket: pid_user_socket}]},
      restart: :temporary
    }

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} -> {:ok, pid}
      error -> error
    end
  end
end
