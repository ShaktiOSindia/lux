defmodule Lux.Lenses.YouTube.CommentsLens do
  @moduledoc """
  Lens for fetching YouTube video comments and sentiment analysis context.
  """

  use Lux.Lens,
    name: "Youtube.CommentsLens",
    description: "Retrieves top comments for a specific YouTube video",
    url: "https://www.googleapis.com/youtube/v3/commentThreads",
    method: :get,
    headers: [{"content-type", "application/json"}],
    schema: %{
      type: :object,
      properties: %{
        videoId: %{
          type: :string,
          description: "The YouTube video ID"
        },
        maxResults: %{
          type: :integer,
          default: 20
        },
        key: %{
          type: :string,
          description: "YouTube Data API v3 Key"
        }
      },
      required: ["videoId", "key"]
    }

  @doc """
  Transforms the API response into a list of comments.
  """
  @impl true
  def after_focus(%{"items" => items}) when is_list(items) do
    comments = Enum.map(items, fn item ->
      get_in(item, ["snippet", "topLevelComment", "snippet", "textDisplay"])
    end)
    {:ok, comments}
  end

  def after_focus(%{"error" => %{"message" => message}}) do
    {:error, message}
  end

  def after_focus(_) do
    {:error, "Failed to fetch comments"}
  end
end
