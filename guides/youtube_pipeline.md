# YouTube Content Creation Pipeline

The YouTube Content Creation Pipeline is a sophisticated, end-to-end workflow designed to automate the production of high-quality YouTube content. It leverages the power of Elixir for orchestration, LLMs for creative writing and SEO, and Python for physical asset generation (thumbnails).

## Architecture

The pipeline follows the idiomatic Lux **Lens-Prism-Beam** pattern:

### 1. Lenses (Data Acquisition)
- **`Lux.Lenses.YouTube.SearchLens`**: Searches YouTube for existing content to provide context and research data for new videos.
- **`Lux.Lenses.YouTube.VideoLens`**: Fetches detailed metadata and statistics for specific videos to benchmark against.

### 2. Prisms (Logic & Processing)
- **`Lux.Prisms.YouTube.ScriptPrism`**: An LLM-backed prism that transforms research and topics into high-retention video scripts with hooks and CTAs.
- **`Lux.Prisms.YouTube.MetadataPrism`**: Generates SEO-optimized titles, descriptions, and tags.
- **`Lux.Prisms.YouTube.ThumbnailPrism`**: A unique hybrid prism that uses a **Python/Pillow** bridge to generate physical `.png` thumbnail images.
- **`Lux.Prisms.YouTube.ABTestingPrism`**: Evaluates different content variants to select the highest potential performer.

### 3. Beams (Orchestration)
- **`Lux.Beams.YouTube.PipelineBeam`**: Chans the lenses and prisms into a unified sequence:
  1. **Research**: Search for top-performing content in the niche.
  2. **Scripting**: Generate a script based on research.
  3. **SEO**: Optimize metadata for the algorithm.
  4. **Visuals**: Generate a physical thumbnail.

## Getting Started

### Prerequisites
- Elixir & Erlang installed.
- Python 3.x with `Pillow` installed.
- A YouTube Data API v3 Key.

### Installation
Ensure Python dependencies are available:
```bash
pip install Pillow
```

### Usage
```elixir
input = %{
  topic: "The Future of AI Agents",
  research_query: "AI Agents 2026",
  tone: "educational",
  api_key: "YOUR_YOUTUBE_API_KEY"
}

{:ok, result} = Lux.Beam.run(Lux.Beams.YouTube.PipelineBeam, input)
```

## Features
- **True Asset Generation**: Unlike other implementations that only suggest ideas, this pipeline creates actual files (Thumbnails).
- **Multi-Language Bridge**: Seamlessly integrates Elixir's reliability with Python's rich ecosystem for image manipulation.
- **SEO Optimized**: Built-in logic for high-CTR metadata generation.

---
*Engineered by ShaktiOSindia (Powered by PK23OS)*
