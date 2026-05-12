defmodule Lux.Agents.YouTubeProducerAgent do
  @moduledoc """
  An autonomous agent dedicated to the full YouTube content lifecycle.
  It researches trends, optimizes metadata, and generates creative assets (scripts, thumbnails).
  """

  use Lux.Agent,
    name: "YouTube Producer Agent",
    description: "Autonomously manages YouTube content intelligence and creation pipelines",
    goal: "Maximize channel growth by producing high-CTR, trend-aligned content",
    capabilities: [:content_intelligence, :content_creation, :asset_generation],
    llm_config: %{
      model: "gpt-4o-mini",
      temperature: 0.7,
      json_response: true
    }

  alias Lux.Beams.YouTube.ContentIntelligenceBeam
  alias Lux.Beams.YouTube.PipelineBeam

  require Logger

  @doc """
  Researches a subject and produces optimized content metadata.
  """
  def research_trends(_agent, subject) do
    Logger.info("[YouTubeProducer] Initiating trend research for: #{subject}")
    ContentIntelligenceBeam.run(%{subject: subject})
  end

  @doc """
  Executes the full content creation pipeline for a subject.
  """
  def produce_content(_agent, subject) do
    Logger.info("[YouTubeProducer] Initiating content production for: #{subject}")
    PipelineBeam.run(%{topic: subject})
  end
end
