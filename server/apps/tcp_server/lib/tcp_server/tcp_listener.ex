defmodule TcpServer.TcpListener do
  @moduledoc false

  use GenServer
  alias TcpServer.ClientSocketDynamicSupervisor

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    IO.puts("Server started on port #{port}")

    {:ok, listen_socket} =
      :gen_tcp.listen(port, [
        :binary,
        packet: :line,
        active: false,
        reuseaddr: true
      ])

    send(self(), :loop)
    {:ok, listen_socket}
  end

  def handle_info(:loop, state) do
    {:ok, socket} = :gen_tcp.accept(state)
    _data = ClientSocketDynamicSupervisor.start_child(socket)
    :timer.sleep(20)
    send(self(), :loop)
    {:noreply, state}
  end
end
