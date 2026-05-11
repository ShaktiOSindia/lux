defmodule Lux.Prisms.YouTube.ScriptPrism do
  @moduledoc """
  A prism that generates a structured YouTube video script based on a topic and research data.
  """

  use Lux.Prism,
    name: "YouTube Script Generator",
    description: "Generates a structured YouTube script with hooks, main content, and CTAs",
    input_schema: %{
      type: :object,
      properties: %{
        topic: %{type: :string, description: "The main topic of the video"},
        research_notes: %{type: :string, description: "Key points or research to include in the script"},
        tone: %{type: :string, enum: ["educational", "entertaining", "informative", "hype"], default: "educational"},
        target_length_mins: %{type: :integer, default: 10}
      },
      required: ["topic"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        title: %{type: :string},
        hook: %{type: :string},
        sections: %{
          type: :array,
          items: %{
            type: :object,
            properties: %{
              heading: %{type: :string},
              content: %{type: :string},
              visual_cues: %{type: :string}
            }
          }
        },
        cta: %{type: :string},
        estimated_duration: %{type: :integer}
      },
      required: ["title", "hook", "sections", "cta"]
    }

  alias Lux.LLM

  def handler(input, ctx) do
    prompt = """
    You are an expert YouTube Scriptwriter. Generate a high-retention script for the following topic:
    Topic: #{input[:topic]}
    Research Notes: #{input[:research_notes] || "General overview of the topic"}
    Tone: #{input[:tone]}
    Target Length: #{input[:target_length_mins]} minutes

    Structure the response as a JSON object matching the following schema:
    - title: Catchy video title
    - hook: First 30 seconds to grab attention
    - sections: Array of {heading, content, visual_cues}
    - cta: Call to action
    - estimated_duration: In seconds
    """

    llm_config = Map.get(ctx, :llm_config, %{})

    case LLM.call(prompt, [], llm_config) do
      {:ok, %{structured_output: script}} when is_map(script) ->
        {:ok, script}

      {:ok, %{content: content}} ->
        case Jason.decode(content) do
          {:ok, script} -> {:ok, script}
          {:error, _} -> {:error, "Failed to parse LLM response as JSON"}
        end

      {:error, reason} ->
        {:error, "LLM Generation Failed: #{inspect(reason)}"}
    end
  end
end
