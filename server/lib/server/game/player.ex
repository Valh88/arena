defmodule Server.Game.Player do
   @moduledoc false
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
      message["coordinates"]
    end
  end
end
