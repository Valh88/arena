defmodule TcpServer.RegistryService do
  @moduledoc false

  @registry_table :registry_table
  def start_registry() do
    IO.puts("start Registry")
    Registry.start_link(keys: :unique, name: @registry_table)
  end

  def register(key) do
    Registry.register(@registry_table, key, self())
  end

  def lookup(key) do
    case Registry.lookup(@registry_table, key) do
      [{pid, _value}] -> pid
      [] -> nil
    end
  end
end
