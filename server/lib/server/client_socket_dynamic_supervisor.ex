defmodule Server.ClientSocketDynamicSupervisor do
  @moduledoc false
  use DynamicSupervisor

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
    spec = {ClientSocketGenserver, %{socket: socket}}

    case DynamicSupervisor.start_child(__MODULE__, spec) do
      {:ok, pid} -> {:ok, pid}
      error -> error
    end
  end
end
