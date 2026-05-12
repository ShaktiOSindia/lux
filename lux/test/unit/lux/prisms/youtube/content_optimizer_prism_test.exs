defmodule Lux.Prisms.YouTube.ContentOptimizerPrismTest do
  use UnitCase, async: true

  alias Lux.Prisms.YouTube.ContentOptimizerPrism

  describe "ContentOptimizerPrism" do
    test "defines expected structure" do
      view = ContentOptimizerPrism.view()
      assert view.name == "YouTube Content Optimizer"
      assert Map.has_key?(view.input_schema.properties, :target_subject)
    end

    test "input schema requires trend_data and target_subject" do
      schema = ContentOptimizerPrism.view().input_schema
      assert schema.required == ["trend_data", "target_subject"]
    end

    test "output schema defines all optimization fields" do
      schema = ContentOptimizerPrism.view().output_schema
      assert schema.required == ["optimized_title", "optimized_description", "suggested_tags", "scoring"]
    end
  end
end
