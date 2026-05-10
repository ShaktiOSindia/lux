defmodule Lux.Prisms.YouTube.ThumbnailPrism do
  use Lux.Prism,
    name: "YouTube Thumbnail Concept",
    description: "Generates visual concepts and text overlays for high-CTR thumbnails.",
    input_schema: %{
      type: "object",
      properties: %{
        "video_title" => %{type: "string"},
        "key_benefit" => %{type: "string"}
      },
      required: ["video_title", "key_benefit"]
    }

  def handler(%{"video_title" => title, "key_benefit" => benefit}, _context) do
    concept = %{
      background_style: "High contrast, gradient with subject in foreground",
      text_overlay: "STOP! #{benefit}",
      face_expression: "Surprised or Intense focus",
      colors: ["#FF0000", "#FFFFFF", "#000000"]
    }

    {:ok, concept}
  end
end
