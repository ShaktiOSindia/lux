defmodule Lux.Prisms.Hyperliquid.HyperliquidMarginPrismTest do
  use UnitCase, async: true

  alias Lux.Prisms.Hyperliquid.HyperliquidMarginPrism

  describe "HyperliquidMarginPrism" do
    test "defines expected structure" do
      view = HyperliquidMarginPrism.view()
      assert view.name == "Hyperliquid Margin Management"
    end

    test "input schema requires coin, is_buy, and ntli" do
      schema = HyperliquidMarginPrism.view().input_schema
      assert schema.required == ["coin", "is_buy", "ntli"]
    end

    test "output schema requires status and result" do
      schema = HyperliquidMarginPrism.view().output_schema
      assert schema.required == ["status", "result"]
    end
  end
end
