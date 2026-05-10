defmodule Lux.Prisms.YouTube.ScriptPrism do
  use Lux.Prism,
    name: "YouTube Script Generator",
    description: "Generates a structured video script with hooks, body, and call-to-action.",
    input_schema: %{
      type: "object",
      properties: %{
        "topic" => %{type: "string", description: "The video topic"},
        "target_audience" => %{type: "string", description: "Who the video is for"},
        "tone" => %{type: "string", enum: ["educational", "entertaining", "formal"], default: "educational"}
      },
      required: ["topic"]
    }

  def handler(%{"topic" => topic, "target_audience" => audience, "tone" => tone}, _context) do
    # This will be handled by the LLM integration in a real run, 
    # but we are building the substrate first.
    script = %{
      hook: "Hey everyone! Today we are diving into #{topic}.",
      segments: [
        %{title: "Introduction", content: "Why #{topic} matters for #{audience}."},
        %{title: "Deep Dive", content: "Explaining the core concepts of #{topic} in a #{tone} tone."},
        %{title: "Summary", content: "Wrapping up what we learned."}
      ],
      cta: "Don't forget to subscribe for more #{topic} content!"
    }

    {:ok, script}
  end
end
