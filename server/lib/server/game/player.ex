defmodule Server.Game.Player do
  @moduledoc false
  alias Server.Game.Player

  defstruct [
    :id,
    :coordinates,
    :rotation,
    :damage,
    :hp,
    :socket_pid,
    :game_pid
  ]

  def decode(message) do
    JSON.decode!(message)
  end

  def parse_data(message) do
    if Map.has_key?(message, "coordinates") do
      {:coordinates, message["coordinates"]}
    end
  end

  def handle(%Player{} = state, message) do
    case parse_data(message) do
      {:coordinates, data} ->
        state = %{state | coordinates: {data["x"], data["y"]}, rotation: data["angle"]}
        send(state.game_pid, {:broadcast, %{player: data}})
        state
    end
  end
end
