defmodule Server.Game.GameGenServer do
  @moduledoc false

  alias Server.ClientSocketDynamicSupervisor
  alias Server.RegistryService
  alias Server.Game.GameLoop

  use GenServer

  def start_link(%{game_id: _game_id} = opt) do
    GenServer.start_link(__MODULE__, opt)
  end

  def init(%{game_id: game_id}) do
    IO.puts("start one game")
    RegistryService.register(game_id)
    state = %GameLoop{id: game_id, count_players: 0, players: []}
    {:ok, state}
  end

  def handle_info({:connect_new_player, pid_user_socket}, state) do
    new_player_id = state.count_players + 1

    {:ok, pid} =
      ClientSocketDynamicSupervisor.start_child_player_state(new_player_id, pid_user_socket)

    state = GameLoop.add_new_player(state, {pid, new_player_id})
    {:noreply, state}
  end

  def handle_info({:delete, player_id}, state) do
    state = GameLoop.delete_player(state, player_id)
    #add broadcast TODO
    {:noreply, state}
  end

  def handle_info({:broadcast, message}, state) do
    GameLoop.broadcast_position(state.players, message)
    {:noreply, state}
  end
end
