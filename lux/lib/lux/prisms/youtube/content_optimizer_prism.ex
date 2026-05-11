defmodule Lux.Prisms.YouTube.ContentOptimizerPrism do
  @moduledoc """
  A prism that analyzes trending data and generates optimized titles, tags, and descriptions.
  """

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
        seo_score: %{type: :number}
      },
      required: ["optimized_title", "optimized_description", "suggested_tags", "seo_score"]
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
    4. Provide an SEO Score (0-100).

    Output ONLY strict JSON:
    {
      "optimized_title": "...",
      "optimized_description": "...",
      "suggested_tags": ["...", "..."],
      "seo_score": 95
    }
    """

    case Lux.LLM.ask(ctx.llm, prompt) do
      {:ok, response} ->
        # Use our robust parsing logic (mocked here, in real OS it uses the Kernel's cleaner)
        case Jason.decode(response) do
          {:ok, decoded} -> {:ok, decoded}
          {:error, _} -> {:error, "Failed to parse LLM response as JSON"}
        end
      {:error, reason} -> {:error, reason}
    end
  end
end
