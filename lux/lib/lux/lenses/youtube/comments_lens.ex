defmodule Lux.Lenses.YouTube.CommentsLens do
  @moduledoc """
  Lens for fetching YouTube video comments and sentiment analysis context.
  """

  alias Lux.Integrations.YouTube

  use Lux.Lens,
    name: "Youtube.CommentsLens",
    description: "Retrieves top comments for a specific YouTube video",
    url: "#{YouTube.base_url()}/commentThreads",
    method: :get,
    headers: YouTube.headers(),
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
        }
      },
      required: ["videoId"]
      }

      def before_focus(params) do
      Map.merge(params, %{"key" => YouTube.api_key(), "part" => "snippet"})
      end

      @doc """
      Transforms the API response into a list of comments.
      """
      @impl true
      def after_focus(%{"items" => items}) do
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
