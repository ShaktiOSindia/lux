defmodule Lux.Prisms.EventStorePrism do
  @moduledoc """
  Stores events in the OS's memory substrate for persistence and replay.
  Uses Lux.Memory.SimpleMemory for chronological storage.
  """

  use Lux.Prism,
    name: "Event Store",
    description: "Persists events to the system memory for auditing and replay",
    input_schema: %{
      type: :object,
      properties: %{
        event: %{type: :object},
        subscription_id: %{type: :string}
      },
      required: ["event", "subscription_id"]
    }

  def handler(input, _ctx) do
    event = input["event"]
    subscription_id = input["subscription_id"]

    # In a production environment, we would use a persistent Lux.Memory backend (like SQLite)
    # For now, we use the registry to find or initialize a memory partition for the subscription
    memory_name = String.to_atom("event_store_#{subscription_id}")

    case Process.whereis(memory_name) do
      nil ->
        Lux.Memory.SimpleMemory.initialize(name: memory_name)
      pid -> pid
    end
    |> Lux.Memory.SimpleMemory.add(event, :observation, %{subscription_id: subscription_id})

    {:ok, %{status: "persisted", memory: memory_name}}
  end
end
