defmodule Lux.Lenses.Hyperliquid.HyperliquidPositionLensTest do
  use UnitCase, async: true

  alias Lux.Lenses.Hyperliquid.HyperliquidPositionLens

  describe "HyperliquidPositionLens" do
    test "defines expected structure" do
      view = HyperliquidPositionLens.view()
      assert view.name == "Hyperliquid Position Info"
      assert view.method == :post
    end

    test "after_focus transforms raw response correctly" do
      mock_response = %{
        "marginSummary" => %{"accountValue" => "1000.0"},
        "crossMarginSummary" => %{"accountValue" => "1000.0"},
        "assetPositions" => [
          %{
            "position" => %{
              "coin" => "ETH",
              "szi" => "0.5",
              "entryPx" => "2500.0",
              "unrealizedPnl" => "100.0",
              "returnOnEquity" => "0.1",
              "liquidationPx" => "2000.0",
              "leverage" => %{"value" => 5.0}
            }
          }
        ]
      }

      {:ok, result} = HyperliquidPositionLens.after_focus(mock_response)
      assert length(result["positions"]) == 1
      assert hd(result["positions"])["coin"] == "ETH"
      assert result["marginSummary"]["accountValue"] == "1000.0"
    end
  end
end
