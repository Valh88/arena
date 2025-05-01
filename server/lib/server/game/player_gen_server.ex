defmodule Server.Game.PlayerGenServer do
  @moduledoc false
  alias Server.RegistryService
  alias Server.Game.Player

  use GenServer

  def start_link(data) do
    GenServer.start_link(__MODULE__, data)
  end

  def init(%{user_id: player_id, pid_user_socket: pid_user_socket}) do
    game_pid = RegistryService.lookup("game_id")

    state = %Player{
      id: player_id,
      coordinates: {1000, 1000},
      rotation: 0,
      game_pid: game_pid,
      socket_pid: pid_user_socket
    }

    send(pid_user_socket, {:hello, {self(), player_id}})
    {:ok, state}
  end

  def handle_info({:message, message}, state) do
    new_state = Player.handle(state, message)
    {:noreply, new_state}
  end

  def handle_info(:disconect, state) do
    send(state.game_pid, {:delete, state.id})
    {:stop, :normal, state}
  end

  def handle_info({:broadcast, message}, state) do
    send(state.socket_pid, {:message, message})
    {:noreply, state}
  end
end
