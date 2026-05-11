defmodule Lux.Beams.YouTube.PipelineBeam do
  @moduledoc """
  The master workflow for automated YouTube content creation.
  """
  use Lux.Beam,
    name: "YouTube Content Pipeline",
    description: "The complete automated workflow for YouTube content creation.",
    input_schema: %{
      type: :object,
      properties: %{
        topic: %{type: :string},
        research_query: %{type: :string},
        tone: %{type: :string, default: "educational"},
        api_key: %{type: :string}
      },
      required: ["topic", "api_key"]
    }

  sequence do
    # 1. Research (Optional if research_query is provided)
    step(:research, Lux.Lenses.YouTube.SearchLens, %{
      q: [:input, :research_query],
      key: [:input, :api_key]
    })

    # 2. Generate Script
    step(:script, Lux.Prisms.YouTube.ScriptPrism, %{
      topic: [:input, :topic],
      research_notes: [:steps, :research, :result],
      tone: [:input, :tone]
    })

    # 3. Generate SEO Metadata
    step(:metadata, Lux.Prisms.YouTube.MetadataPrism, %{
      script_summary: [:steps, :script, :result, :hook],
      keywords: ["AI", "Automation", "PK23OS"]
    })

    # 4. Generate Thumbnail
    step(:thumbnail, Lux.Prisms.YouTube.ThumbnailPrism, %{
      title: [:steps, :metadata, :result, :suggested_titles, 0],
      background_color: "#FF0000"
    })
  end
end
