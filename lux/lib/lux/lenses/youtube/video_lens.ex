defmodule Lux.Lenses.YouTube.VideoLens do
  @moduledoc """
  Lens for fetching YouTube video information and statistics using the YouTube Data API v3.
  """

  alias Lux.Integrations.YouTube

  use Lux.Lens,
    name: "Youtube.VideoLens",
    description: "Retrieves metadata, snippets, and statistics for a specific YouTube video",
    url: "#{YouTube.base_url()}/videos",
    method: :get,
    headers: YouTube.headers(),
    schema: %{
      type: :object,
      properties: %{
        id: %{
          type: :string,
          description: "The YouTube video ID"
        },
        part: %{
          type: :string,
          description: "Comma-separated list of video resource properties (snippet, statistics, contentDetails)",
          default: "snippet,statistics"
        }
      },
      required: ["id"]
    }

  def before_focus(params) do
    Map.merge(params, %{"key" => YouTube.api_key()})
  end

  @doc """
  Transforms the API response into the Lux format.
  """
  @impl true
  def after_focus(%{"items" => [video | _]}) do
    {:ok,
     %{
       title: get_in(video, ["snippet", "title"]),
       description: get_in(video, ["snippet", "description"]),
       view_count: get_in(video, ["statistics", "viewCount"]),
       like_count: get_in(video, ["statistics", "likeCount"]),
       published_at: get_in(video, ["snippet", "publishedAt"]),
       tags: get_in(video, ["snippet", "tags"]) || []
     }}
  end

  def after_focus(%{"error" => %{"message" => message}}) do
    {:error, message}
  end

  def after_focus(_) do
    {:error, "Video not found or invalid response"}
  end
end
