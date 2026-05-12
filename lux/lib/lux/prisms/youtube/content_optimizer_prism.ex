defmodule Lux.Prisms.YouTube.ContentOptimizerPrism do
  @moduledoc """
  A prism that analyzes trending data and generates optimized titles, tags, and descriptions.
  """

  alias Lux.LLM
  alias Lux.Schemas.YouTubeScoreSchema

  use Lux.Prism,
    name: "YouTube Content Optimizer",
    description: "Generates optimized metadata and SEO scoring for YouTube content",
    input_schema: %{
      type: :object,
      properties: %{
        trend_data: %{type: :object},
        target_subject: %{type: :string}
      },
      required: ["trend_data", "target_subject"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        optimized_title: %{type: :string},
        optimized_description: %{type: :string},
        suggested_tags: %{type: :array, items: %{type: :string}},
        scoring: YouTubeScoreSchema.definition()
      },
      required: ["optimized_title", "optimized_description", "suggested_tags", "scoring"]
    }

  def handler(input, ctx) do
    # Excellence: Leverage the Kernel's LLM via context
    prompt = """
    You are an Expert YouTube SEO Strategist.
    SUBJECT: #{input.target_subject}
    TREND DATA: #{inspect(input.trend_data)}

    TASK:
    1. Generate a high-CTR title.
    2. Write a compelling, keyword-rich description.
    3. Suggest 15 trending tags.
    4. Provide a granular SEO Score breakdown.

    Output ONLY strict JSON:
    {
      "optimized_title": "...",
      "optimized_description": "...",
      "suggested_tags": ["...", "..."],
      "scoring": {
        "overall_score": 95,
        "metrics": {
          "keyword_relevance": 0.9,
          "trend_affinity": 0.8,
          "engagement_potential": 0.95,
          "ctr_optimization": 0.85
        },
        "recommendations": ["Use more emotional hooks", "Add call to action"]
      }
    }
    """

    llm_config = Map.get(ctx, :llm_config, %{})

    case LLM.call(prompt, [], llm_config) do
      {:ok, %{structured_output: report}} when is_map(report) ->
        {:ok, report}

      {:ok, %{content: content}} ->
        # Use our robust parsing logic (mocked here, in real OS it uses the Kernel's cleaner)
        case Jason.decode(content) do
          {:ok, decoded} -> {:ok, decoded}
          {:error, _} -> {:error, "Failed to parse LLM response as JSON"}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end
end
