defmodule Lux.Prisms.YouTube.MetadataPrism do
  @moduledoc """
  A prism that generates SEO-optimized titles, descriptions, and tags for YouTube videos.
  """

  use Lux.Prism,
    name: "YouTube Metadata Generator",
    description: "Generates SEO-optimized titles, descriptions, and tags for YouTube videos.",
    input_schema: %{
      type: :object,
      properties: %{
        script_summary: %{type: :string, description: "Summary of the video script or content"},
        keywords: %{type: :array, items: %{type: :string}, default: ["AI", "Automation"]}
      },
      required: ["script_summary"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        suggested_titles: %{type: :array, items: %{type: :string}},
        description: %{type: :string},
        tags: %{type: :array, items: %{type: :string}}
      },
      required: ["suggested_titles", "description", "tags"]
    }

  alias Lux.LLM

  def handler(input, ctx) do
    prompt = """
    You are an expert YouTube SEO Consultant. Generate optimized metadata for a video with the following summary:
    Summary: #{input[:script_summary]}
    Keywords: #{Enum.join(input[:keywords] || [], ", ")}

    Return a JSON object with:
    - suggested_titles: 3 high-CTR titles
    - description: A compelling video description with timestamps placeholders
    - tags: 15-20 relevant tags
    """

    llm_config = Map.get(ctx, :llm_config, %{})

    case LLM.call(prompt, [], llm_config) do
      {:ok, %{structured_output: metadata}} when is_map(metadata) ->
        {:ok, metadata}

      {:ok, %{content: content}} ->
        case Jason.decode(content) do
          {:ok, metadata} -> {:ok, metadata}
          {:error, _} -> {:error, "Failed to parse Metadata analysis"}
        end

      {:error, reason} ->
        {:error, "Metadata Generation Failed: #{inspect(reason)}"}
    end
  end
end
