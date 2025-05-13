defmodule Server.ClientSocketGenserver do
  @moduledoc false
  alias Server.RegistryService
  alias Server.ClientSocket

  use GenServer

  # Запуск процесса
  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  @impl true
  def init(%{socket: socket}) do
    on_connect()
    {:ok, %{socket: socket}}
  end

  # Обработка сообщений
  @impl true
  def handle_info(:loop, state) do
    ClientSocket.handle_client(state)
    {:noreply, state}
  end

  @impl true
  def handle_info({:message, data}, %{socket: socket} = state) do
    json = JSON.encode!(data)
    :gen_tcp.send(socket, json <> "\n")
    {:noreply, state}
  end

  def handle_info({:hello, {player_state_pid, player_id}}, %{socket: socket}) do
    json = JSON.encode!(%{connect: %{user: player_id}})
    :gen_tcp.send(socket, json <> "\n")
    {:noreply, %{socket: socket, player_state_pid: player_state_pid}}
  end

  @impl true
  def terminate(reason, %{socket: socket} = _state) do
    IO.puts("Terminating with reason: #{inspect(reason)}")

    :gen_tcp.close(socket)

    :ok
  end

  @impl true
  def handle_cast(:on_connect, state) do
    game_pid = RegistryService.lookup("game_id")
    send(game_pid, {:connect_new_player, self()})
    send(self(), :loop)
    {:noreply, state}
  end

  @impl true
  def handle_cast(:on_disconnect, %{socket: _socket, player_state_pid: player_state_pid} = state) do
    send(player_state_pid, :disconect)
    {:stop, :normal, state}
  end


  def on_connect() do
    GenServer.cast(self(), :on_connect)
  end

  def on_disconnect() do
    GenServer.cast(self(), :on_disconnect)
  end
end
