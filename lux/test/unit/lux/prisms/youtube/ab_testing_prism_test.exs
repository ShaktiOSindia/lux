defmodule Lux.Prisms.Youtube.ABTestingPrismTest do
  use ExUnit.Case
  alias Lux.Prisms.Youtube.ABTestingPrism

  test "handler evaluates variants and picks a winner" do
    input = %{
      topic: "Building SovereignOS",
      criteria: "click-through rate",
      variants: [
        %{id: "A", hook: "Stop building apps, start building empires.", title: "Why I stopped coding apps"},
        %{id: "B", hook: "The 3 pillars of autonomous business.", title: "SovereignOS Business Guide"}
      ]
    }

    # Execute the handler directly (assuming unit-test context provides enough config or a mock)
    # Since Lux.Prism tests usually run in an Agent context, we simulate here
    {:ok, result} = ABTestingPrism.handler(input, %{llm_config: %{}})

    assert Map.has_key?(result, "winner_id")
    assert Map.has_key?(result, "reasoning")
    assert result["winner_id"] in ["A", "B"]
  end
end
