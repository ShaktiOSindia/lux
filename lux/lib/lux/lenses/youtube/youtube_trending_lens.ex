defmodule Lux.Lenses.YouTube.YouTubeTrendingLens do
  @moduledoc """
  A lens that fetches trending YouTube topics and metadata using the YouTube Data API.
  """

  alias Lux.Config

  use Lux.Lens,
    name: "YouTube Trending Intelligence",
    description: "Fetches trending video data and topic metadata from YouTube",
    method: :get,
    url: "https://www.googleapis.com/youtube/v3/videos",
    schema: %{
      type: :object,
      properties: %{
        regionCode: %{type: :string, default: "US"},
        chart: %{type: :string, default: "mostPopular"},
        videoCategoryId: %{type: :string, optional: true}
      }
    }

  def before_focus(params) do
    # Google API Key is required
    api_key = Application.get_env(:lux, :api_keys)[:google_youtube] || ""
    Map.merge(params, %{"key" => api_key, "part" => "snippet,statistics,contentDetails"})
  end

  def after_focus(%{"items" => items}) do
    processed = Enum.map(items, fn item ->
      %{
        "id" => item["id"],
        "title" => item["snippet"]["title"],
        "description" => item["snippet"]["description"],
        "viewCount" => item["statistics"]["viewCount"],
        "likeCount" => item["statistics"]["likeCount"],
        "commentCount" => item["statistics"]["commentCount"],
        "tags" => item["snippet"]["tags"] || [],
        "duration" => item["contentDetails"]["duration"]
      }
    end)
    {:ok, %{"trending_videos" => processed}}
  end

  def after_focus(error), do: {:error, error}
end
