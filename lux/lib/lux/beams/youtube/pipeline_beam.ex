defmodule Lux.Beams.YouTube.PipelineBeam do
  use Lux.Beam,
    name: "YouTube Content Pipeline",
    description: "The complete automated workflow for YouTube content creation.",
    input_schema: %{
      type: "object",
      properties: %{
        "topic" => %{type: "string"},
        "audience" => %{type: "string"}
      },
      required: ["topic"]
    }

  def steps do
    sequence do
      # 1. Generate Script
      step(:script, Lux.Prisms.YouTube.ScriptPrism, %{
        topic: [:input, "topic"],
        target_audience: [:input, "audience"]
      })

      # 2. Generate SEO Metadata
      step(:metadata, Lux.Prisms.YouTube.MetadataPrism, %{
        script_summary: [:script, "hook"],
        keywords: ["ai", "automation", "lux"]
      })

      # 3. Generate Thumbnail Concept
      step(:thumbnail, Lux.Prisms.YouTube.ThumbnailPrism, %{
        video_title: [:metadata, "suggested_titles", 0],
        key_benefit: "Save 10 Hours"
      })
    end
  end
end
