defmodule Lux.Beams.YouTube.ContentIntelligenceBeam do
  @moduledoc """
  A beam that identifies trending topics and optimizes content intelligence for YouTube.
  """

  use Lux.Beam,
    name: "YouTube Content Intelligence",
    description: "Autonomously researches trends and optimizes content metadata",
    input_schema: %{
      type: :object,
      properties: %{
        subject: %{type: :string},
        region: %{type: :string, default: "US"}
      },
      required: ["subject"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        intelligence_report: %{type: :object}
      }
    },
    generate_execution_log: true

  alias Lux.Lenses.YouTube.YouTubeTrendingLens
  alias Lux.Prisms.YouTube.ContentOptimizerPrism

  sequence do
    # 1. Fetch current trending data
    step(:trends, YouTubeTrendingLens, %{regionCode: [:input, :region]})

    # 2. Optimize content metadata based on trends
    step(:optimization, ContentOptimizerPrism, %{
      trend_data: [:steps, :trends, :result],
      target_subject: [:input, :subject]
    })
  end
end
