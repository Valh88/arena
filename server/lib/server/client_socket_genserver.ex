defmodule Server.ClientSocketGenserver do
  @moduledoc false
  alias Credo.CLI.Command.Categories.Output.Json
  alias Server.ClientSocket

  use GenServer

  # Запуск процесса
  def start_link(socket) do
    GenServer.start_link(__MODULE__, socket)
  end

  # Инициализация состояния
  @impl true
  def init(%{socket: socket}) do
    on_connect()
    {:ok, %{socket: socket}}
  end

  # Обработка сообщений
  @impl true
  def handle_info(:loop, %{socket: socket} = state) do
    ClientSocket.handle_client(%{socket: socket})
    {:noreply, state}
  end

  @impl true
  def handle_info({:message, data}, %{socket: socket} = state) do
    json = JSON.encode!(data)
    IO.puts(json)
    :gen_tcp.send(socket, json <> "\n")
    {:noreply, state}
  end


  @impl true
  def terminate(reason, %{socket: socket} = _state) do
    IO.puts("Terminating with reason: #{inspect(reason)}")

    :gen_tcp.close(socket)

    :ok
  end

  @impl true
  def handle_cast(:on_connect, state) do
    IO.inspect("New connect")
    send(self(), :loop)
    {:noreply, state}
  end


  @impl true
  def handle_cast(:on_disconnect, state) do
    IO.inspect("Client disconnected")
    {:stop, :normal, state}
  end


  def on_connect() do
    GenServer.cast(self(), :on_connect)
  end

  def on_disconnect() do
    GenServer.cast(self(), :on_disconnect)
  end
end
