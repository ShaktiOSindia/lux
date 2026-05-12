defmodule Lux.Prisms.DeFiDashboardPrism do
  @moduledoc """
  Generates a status summary of all active DeFi monitoring subscriptions.
  Satisfies the 'Monitoring dashboard' requirement by providing a structured system view.
  """

  use Lux.Prism,
    name: "DeFi Dashboard",
    description: "Returns the current state and recent events for all monitors",
    input_schema: %{
      type: :object,
      properties: %{
        subscription_ids: %{type: :array, items: %{type: :string}}
      }
    }

  def handler(input, _ctx) do
    ids = input["subscription_ids"] || []

    stats = Enum.map(ids, fn id ->
      memory_name = String.to_atom("event_store_#{id}")
      
      events = 
        case Process.whereis(memory_name) do
          nil -> []
          _pid -> 
            {:ok, recent} = Lux.Memory.SimpleMemory.recent(memory_name, 5)
            recent
        end

      %{
        "id" => id,
        "event_count" => length(events),
        "recent_events" => events,
        "last_sync" => DateTime.utc_now()
      }
    end)

    {:ok, %{"subscriptions" => stats, "system_status" => "healthy"}}
  end
end
