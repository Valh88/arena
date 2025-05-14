defmodule Game.GameLoop do
  @moduledoc false

  defstruct [
    :id,
    :count_players,
    :players
  ]

  def add_new_player(state, {_game_player_state, player_id} = data) do
    players = [data | state.players]
    %{state | count_players: player_id, players: players}
  end

  def delete_player(state, player_id) do
    players = Enum.filter(state.players, fn {_game_player_state, id} -> id != player_id end)
    count_players = state.count_players - 1

    for {game_player_state, id} <- players do
      if id != player_id do
        send(game_player_state, {:broadcast, %{deletePlayer: %{playerId: player_id}}})
      end
    end

    %{state | count_players: count_players, players: players}
  end

  def broadcast_position(players, data) do
    for {game_player_state, id} <- players do
      if id != data[:player]["playerId"] do
        send(game_player_state, {:broadcast, data})
      end
    end
  end
end
