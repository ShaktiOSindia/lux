defmodule Lux.Prisms.YouTube.ABTestingPrismTest do
  use UnitCase, async: true
  alias Lux.Prisms.YouTube.ABTestingPrism

  test "defines expected structure" do
    view = ABTestingPrism.view()
    assert view.name == "YouTube A/B Tester"
    assert Map.has_key?(view.input_schema.properties, :variants)
  end

  test "output schema requires winner_id and reasoning" do
    schema = ABTestingPrism.view().output_schema
    assert schema.required == ["winner_id", "reasoning"]
  end
end
