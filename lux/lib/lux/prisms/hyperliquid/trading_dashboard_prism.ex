defmodule Lux.Prisms.Hyperliquid.TradingDashboardPrism do
  @moduledoc """
  Generates a real-time trading dashboard summary for Hyperliquid.
  Aggregates PnL, open positions, and margin status.
  """

  use Lux.Prism,
    name: "Hyperliquid Trading Dashboard",
    description: "Summarizes account performance and risk metrics",
    input_schema: %{
      type: :object,
      properties: %{
        user_state: %{type: :object},
        positions: %{type: :array, items: %{type: :object}}
      },
      required: ["user_state"]
    }

  def handler(input, _ctx) do
    user_state = input["user_state"]
    positions = input["positions"] || []

    # Calculate aggregate metrics for the Dashboard
    total_pnl = 
      positions 
      |> Enum.map(fn p -> String.to_float(p["unrealizedPnl"] || "0.0") end) 
      |> Enum.sum()

    margin_usage = get_in(user_state, ["marginSummary", "accountValue"])

    {:ok, %{
      "account_summary" => %{
        "total_unrealized_pnl" => total_pnl,
        "margin_usage" => margin_usage,
        "active_positions_count" => length(positions)
      },
      "system_status" => "monitoring",
      "timestamp" => DateTime.utc_now()
    }}
  end
end
