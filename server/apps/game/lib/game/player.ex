defmodule Game.Player do
  @moduledoc false
  alias Game.Player

  defstruct [
    :id,
    :coordinates,
    :rotation,
    :damage,
    :hp,
    :socket_pid,
    :game_pid,
    :history
  ]

  defp get_server_time(ms) do
    System.system_time(ms)
  end

  def decode(message) do
    JSON.decode!(message)
  end

  def parse_data(message) do
    cond do
      Map.has_key?(message, "coordinates") -> {:coordinates, message["coordinates"]}
      Map.has_key?(message, "shot") -> {:shot, message["shot"]}
    end
  end

  def handle(%Player{} = state, message) do
    case parse_data(message) do
      {:coordinates, data} ->
        state = %{state | coordinates: {data["x"], data["y"]}, rotation: data["angle"]}
        |> save_current_state_in_history(data["timestamp"])
        send(state.game_pid, {:broadcast, %{player: %{data | "timestamp" => get_server_time(:millisecond)}}})
        state
      {:shot, data} ->
        send(state.game_pid, {:broadcast, %{shot: %{data | "timestamp" => get_server_time(:millisecond) - 50}}})
        state
    end
  end

  def save_current_state_in_history(state, client_time) do
    history =
      Map.put(state.history, client_time, state)
      |> Enum.filter(fn {ts_key, _st_value} -> ts_key >= get_server_time(:millisecond) - 250 end)
      |> Map.new()
    %{state | history: history}
  end
end
