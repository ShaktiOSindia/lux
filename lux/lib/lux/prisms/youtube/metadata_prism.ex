defmodule Lux.Prisms.YouTube.MetadataPrism do
  use Lux.Prism,
    name: "YouTube Metadata Generator",
    description: "Generates SEO-optimized titles, descriptions, and tags for YouTube videos.",
    input_schema: %{
      type: "object",
      properties: %{
        "script_summary" => %{type: "string", description: "Summary of the video script"},
        "keywords" => %{type: "array", items: %{type: "string"}}
      },
      required: ["script_summary"]
    }

  def handler(%{"script_summary" => summary, "keywords" => keywords}, _context) do
    metadata = %{
      suggested_titles: [
        "Mastering #{summary} in 2025",
        "The Ultimate Guide to #{summary}",
        "Why you need to know about #{summary}"
      ],
      description: "In this video, we explore #{summary}. Keywords: #{Enum.join(keywords, ", ")}",
      tags: keywords ++ ["youtube", "tutorial", "lux"]
    }

    {:ok, metadata}
  end
end
