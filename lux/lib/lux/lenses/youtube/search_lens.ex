defmodule Lux.Lenses.YouTube.SearchLens do
  @moduledoc """
  Lens for searching YouTube videos and channels using the YouTube Data API v3.
  """

  use Lux.Lens,
    name: "Youtube.SearchLens",
    description: "Searches for YouTube content matching a specific query",
    url: "https://www.googleapis.com/youtube/v3/search",
    method: :get,
    headers: [{"content-type", "application/json"}],
    schema: %{
      type: :object,
      properties: %{
        q: %{
          type: :string,
          description: "The search query term"
        },
        part: %{
          type: :string,
          description: "Comma-separated list of video resource properties",
          default: "snippet"
        },
        type: %{
          type: :string,
          description: "Restrict search to a particular type of resource (video, channel, playlist)",
          default: "video"
        },
        maxResults: %{
          type: :integer,
          default: 5
        },
        key: %{
          type: :string,
          description: "YouTube Data API v3 Key"
        }
      },
      required: ["q", "key"]
    }

  @doc """
  Transforms the API response into a list of search results.
  """
  @impl true
  def after_focus(%{"items" => items}) when is_list(items) do
    results = Enum.map(items, fn item ->
      %{
        id: get_in(item, ["id", "videoId"]),
        title: get_in(item, ["snippet", "title"]),
        description: get_in(item, ["snippet", "description"]),
        channel_title: get_in(item, ["snippet", "channelTitle"]),
        published_at: get_in(item, ["snippet", "publishedAt"])
      }
    end)
    {:ok, results}
  end

  def after_focus(%{"error" => %{"message" => message}}) do
    {:error, message}
  end

  def after_focus(_) do
    {:error, "Search failed or invalid response"}
  end
end
