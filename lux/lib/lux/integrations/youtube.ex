defmodule Lux.Integrations.YouTube do
  @moduledoc """
  Integration with the YouTube Data API for content intelligence and management.
  """

  @type api_key :: String.t()

  @doc """
  Gets the configured Google YouTube API key.
  """
  @spec api_key() :: api_key()
  def api_key do
    Application.fetch_env!(:lux, :api_keys)[:google_youtube]
  end

  @doc """
  Gets the configured YouTube Data API base URL.
  """
  @spec base_url() :: String.t()
  def base_url do
    "https://www.googleapis.com/youtube/v3"
  end

  @doc """
  Gets the default headers for YouTube API requests.
  """
  @spec headers() :: [{String.t(), String.t()}]
  def headers do
    [
      {"Accept", "application/json"}
    ]
  end

  @doc """
  Authenticates a lens for YouTube API requests.
  Adds the key parameter to the request.
  """
  @spec authenticate(map()) :: map()
  def authenticate(lens) do
    # For GET requests, we usually add the key to the params
    Map.update!(lens, :params, fn params ->
        Map.put(params, "key", api_key())
    end)
  end
end
