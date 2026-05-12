defmodule Lux.Prisms.EventFilterPrism do
  @moduledoc """
  Filters decoded events based on subscription criteria.
  Supports threshold checks, address matching, and pattern matching.
  """

  use Lux.Prism,
    name: "Event Filter",
    description: "Filters events based on subscription criteria",
    input_schema: %{
      type: :object,
      properties: %{
        events: %{type: :array, items: %{type: :object}},
        subscription: %{
          type: :object,
          properties: %{
            filters: %{type: :object}
          }
        }
      },
      required: ["events", "subscription"]
    }

  def handler(input, _ctx) do
    events = input["events"]
    subscription = input["subscription"]
    filters = subscription["filters"] || %{}

    filtered =
      Enum.filter(events, fn event ->
        matches_filters?(event, filters)
      end)

    {:ok, %{"filtered_events" => filtered}}
  end

  defp matches_filters?(_event, filters) when filters == %{}, do: true

  defp matches_filters?(event, filters) do
    # Simple recursive matching
    Enum.all?(filters, fn {key, value} ->
      event_value = get_in(event, ["params", key]) || event[key]
      compare(event_value, value)
    end)
  end

  defp compare(val, %{"gt" => limit}), do: val > limit
  defp compare(val, %{"lt" => limit}), do: val < limit
  defp compare(val, expected), do: val == expected
end
