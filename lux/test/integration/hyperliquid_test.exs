defmodule Lux.Integration.HyperliquidTest do
  use ExUnit.Case, async: false

  alias Lux.Lenses.Hyperliquid.HyperliquidMarketLens
  alias Lux.Lenses.Hyperliquid.HyperliquidPositionLens
  alias Lux.Prisms.Hyperliquid.HyperliquidMarginPrism
  alias Lux.Beams.Hyperliquid.LiquidationMonitorBeam

  @test_address "0x0403369c02199a0cb827f4d6492927e9fa5668d5"

  describe "Hyperliquid Lenses" do
    test "HyperliquidMarketLens fetches market data" do
      {:ok, result} = HyperliquidMarketLens.focus(%{})
      assert Map.has_key?(result, "assets")
      assert Map.has_key?(result["assets"], "BTC")
      assert is_map(result["assets"]["BTC"])
    end

    test "HyperliquidPositionLens fetches user positions" do
      {:ok, result} = HyperliquidPositionLens.focus(%{"user" => @test_address})
      assert Map.has_key?(result, "positions")
      assert Map.has_key?(result, "marginSummary")
    end
  end

  describe "Hyperliquid Prisms" do
    test "HyperliquidMarginPrism validates input" do
      # Note: We can't easily test live execution without a private key, 
      # but we can test the Prism's response to missing keys.
      result = HyperliquidMarginPrism.run(%{
        coin: "ETH",
        is_buy: true,
        ntli: 10
      })
      
      case result do
        {:error, reason} -> assert is_binary(reason)
        {:ok, _} -> flunk("Should not succeed without private key")
      end
    end
  end

  describe "Hyperliquid Beams" do
    test "LiquidationMonitorBeam completes sequence" do
      # This test verifies the beam can coordinate the steps even if it logs safe
      {:ok, result} = LiquidationMonitorBeam.run(%{"risk_threshold" => 0.9})
      # The beam should at least return a status from its branches
      assert result != nil
    end
  end
end
