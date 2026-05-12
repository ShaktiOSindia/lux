# YouTube Pipeline Examples

This expansion pack enables Lux to autonomously handle the full YouTube content creation lifecycle.

## How to run the pipeline

```elixir
alias Lux.Beams.YouTube.PipelineBeam

input = %{
  "topic" => "The Future of Multi-Agent Systems",
  "audience" => "AI Researchers"
}

{:ok, result} = Lux.Beam.run(PipelineBeam, input)

# result contains:
# - result.script: Video hooks and segments
# - result.metadata: SEO titles and tags
# - result.thumbnail: Visual concepts
```

## Prisms included:
1. `Lux.Prisms.YouTube.ScriptPrism`
2. `Lux.Prisms.YouTube.MetadataPrism`
3. `Lux.Prisms.YouTube.ThumbnailPrism`
