defmodule Lux.Lenses.Hyperliquid.HyperliquidMarketLensTest do
  use UnitCase, async: true

  alias Lux.Lenses.Hyperliquid.HyperliquidMarketLens

  describe "HyperliquidMarketLens" do
    test "defines expected structure" do
      view = HyperliquidMarketLens.view()
      assert view.name == "Hyperliquid Market Info"
      assert view.method == :post
    end

    test "after_focus transforms raw response correctly" do
      mock_response = [
        %{
          "universe" => [
            %{"name" => "BTC", "szDecimals" => 5}
          ]
        },
        [
          %{
            "markPx" => "104000.0",
            "midPx" => "104000.1",
            "funding" => "0.00001",
            "openInterest" => "100.0",
            "dayNtlVlm" => "1000000.0"
          }
        ]
      ]

      {:ok, %{"assets" => assets}} = HyperliquidMarketLens.after_focus(mock_response)
      assert Map.has_key?(assets, "BTC")
      assert assets["BTC"]["markPx"] == "104000.0"
      assert assets["BTC"]["szDecimals"] == 5
    end
  end
end
