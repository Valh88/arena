defmodule Server.ClientSocket do
  @moduledoc false
alias Server.ClientSocketGenserver

  def handle_client(%{socket: socket}) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, data} ->
        data = String.trim(data)
        data = JSON.decode!(String.trim_leading(data, <<0>>))
        send(self(), {:message,  data})
        send(self(), :loop)
      {:error, :closed} ->
        ClientSocketGenserver.on_disconnect()
    end
  end
end
