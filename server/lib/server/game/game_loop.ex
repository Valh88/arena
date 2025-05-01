defmodule Server.Game.GameLoop do
  @moduledoc false

  defstruct [
    :id,
    :count_players,
    :players,

  ]

  def add_new_player(state,  {_game_player_state, player_id} = data) do
    players = [data | state.players]
    %{state | count_players: player_id, players: players}
  end
end
