defmodule Lux.Prisms.YouTube.ABTestingPrism do
  @moduledoc """
  A prism that manages A/B testing for YouTube content variants.
  """

  use Lux.Prism,
    name: "YouTube A/B Content Tester",
    description: "Evaluates two variations of YouTube content to determine the optimal hook or title",
    input_schema: %{
      type: :object,
      properties: %{
        topic: %{type: :string},
        variants: %{
          type: :array,
          items: %{
            type: :object,
            properties: %{
              id: %{type: :string},
              hook: %{type: :string},
              title: %{type: :string}
            }
          }
        },
        criteria: %{type: :string, description: "Metric to optimize for (e.g., 'click-through rate', 'retention')"}
      },
      required: ["variants", "criteria"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        winner_id: %{type: :string},
        reasoning: %{type: :string},
        expected_performance: %{type: :string}
      },
      required: ["winner_id", "reasoning"]
    }

  alias Lux.LLM

  def handler(input, ctx) do
    prompt = """
    You are an expert YouTube Analytics Consultant. 
    Compare the following video variants and choose the winner based on #{input[:criteria]}.

    Topic: #{input[:topic]}
    Variants: 
    #{Enum.map(input[:variants], fn v -> "ID: #{v[:id]} | Hook: #{v[:hook]} | Title: #{v[:title]}" end) |> Enum.join("\n")}

    Return a JSON object with:
    - winner_id: ID of the best variant
    - reasoning: Why this variant will perform better
    - expected_performance: A brief prediction
    """

    llm_config = Map.get(ctx, :llm_config, %{})

    case LLM.call(prompt, [], llm_config) do
      {:ok, %{structured_output: analysis}} when is_map(analysis) ->
        {:ok, analysis}
      {:ok, %{content: content}} ->
        case Jason.decode(content) do
          {:ok, analysis} -> {:ok, analysis}
          {:error, _} -> {:error, "Failed to parse A/B test analysis"}
        end
      {:error, reason} ->
        {:error, "A/B Testing Generation Failed: #{inspect(reason)}"}
    end
  end
end
