defmodule Lux.Beams.Hyperliquid.LiquidationMonitorBeam do
  @moduledoc """
  A beam that monitors open Hyperliquid positions for liquidation risk.
  If a position is at high risk, it attempts to mitigate the risk by adding margin or reducing position size.
  """

  use Lux.Beam,
    name: "Hyperliquid Liquidation Monitor",
    description: "Monitors and protects Hyperliquid positions from liquidation",
    input_schema: %{
      type: :object,
      properties: %{
        risk_threshold: %{
          type: :number,
          description: "Risk level (0-1) at which mitigation triggers. Default 0.8.",
          default: 0.8
        }
      }
    },
    output_schema: %{
      type: :object,
      properties: %{
        monitored_positions: %{type: :integer},
        mitigations_executed: %{type: :integer},
        results: %{type: :array}
      }
    },
    generate_execution_log: true

  alias Lux.Lenses.Hyperliquid.HyperliquidPositionLens
  alias Lux.Prisms.Hyperliquid.HyperliquidRiskAssessmentPrism
  alias Lux.Prisms.Hyperliquid.HyperliquidTokenInfoPrism
  alias Lux.Prisms.Hyperliquid.HyperliquidMarginPrism

  sequence do
    # 1. Fetch current positions
    step(:positions, HyperliquidPositionLens, %{})

    # 2. Fetch market data for accurate pricing
    step(:market_data, HyperliquidTokenInfoPrism, %{})

    # 3. Analyze each position for risk
    # In a real beam, we would loop over positions. For now, we take the most risky one.
    step(:risk_check, HyperliquidRiskAssessmentPrism, %{
      portfolio: [:steps, :positions, :result],
      market_data: [:steps, :market_data, :result, :prices]
    })

    # 4. Mitigation Logic
    branch {__MODULE__, :is_high_risk?} do
      true ->
        step(:mitigate, HyperliquidMarginPrism, %{
          coin: [:steps, :risk_check, :result, :symbol],
          is_buy: [:steps, :risk_check, :result, :is_buy],
          ntli: 100 # Add $100 margin as a safety buffer
        })
      false ->
        step(:log_safe, Lux.Prisms.NoOp, %{
          status: "safe",
          message: "All positions within safe risk bounds"
        })
    end
  end

  def is_high_risk?(ctx) do
    metrics = ctx.steps.risk_check.result
    threshold = ctx.input["risk_threshold"] || 0.8
    metrics["liquidation_risk"] >= threshold
  end
end
