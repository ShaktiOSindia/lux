defmodule Lux.Schemas.YouTubeScoreSchema do
  @moduledoc """
  Schema for YouTube SEO and performance scoring.
  Provides a granular breakdown of how the intelligence score is calculated.
  """

  def definition do
    %{
      type: :object,
      properties: %{
        overall_score: %{
          type: :number,
          minimum: 0,
          maximum: 100,
          description: "Weighted average SEO readiness score"
        },
        metrics: %{
          type: :object,
          properties: %{
            keyword_relevance: %{type: :number, minimum: 0, maximum: 1, description: "Alignment with trending keywords"},
            trend_affinity: %{type: :number, minimum: 0, maximum: 1, description: "Recency and velocity of the topic"},
            engagement_potential: %{type: :number, minimum: 0, maximum: 1, description: "Predicted comment and share rate"},
            ctr_optimization: %{type: :number, minimum: 0, maximum: 1, description: "Title and thumbnail hook strength"}
          },
          required: ["keyword_relevance", "trend_affinity", "engagement_potential", "ctr_optimization"]
        },
        recommendations: %{
          type: :array,
          items: %{type: :string},
          description: "Specific actions to improve the score"
        }
      },
      required: ["overall_score", "metrics"]
    }
  end
end
