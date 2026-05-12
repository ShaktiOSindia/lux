defmodule Lux.Lenses.Hyperliquid.HyperliquidPositionLens do
  @moduledoc """
  A lens that fetches account state and open positions from Hyperliquid.
  """

  alias Lux.Integrations.Hyperliquid

  use Lux.Lens,
    name: "Hyperliquid Position Info",
    description: "Fetches account state and open positions from Hyperliquid",
    method: :post,
    url: Hyperliquid.info_url(),
    headers: Hyperliquid.headers(),
    schema: %{
      type: :object,
      properties: %{
        user: %{
          type: :string,
          description: "Ethereum address of the user. If not provided, uses configured address.",
          pattern: "^0x[a-fA-F0-9]{40}$"
        }
      }
    }

  def before_focus(params) do
    user_address = params["user"] || Hyperliquid.address()

    if user_address == "" or is_nil(user_address) do
        raise "No user address provided or configured for HyperliquidPositionLens"
    end

    Map.merge(params, %{"type" => "clearinghouseState", "user" => user_address})
  end

  def after_focus(body) do
    case body do
      %{"assetPositions" => positions} ->
        processed_positions = 
          Enum.map(positions, fn %{"position" => p} -> 
            %{
                "coin" => p["coin"],
                "szi" => p["szi"],
                "entryPx" => p["entryPx"],
                "unrealizedPnl" => p["unrealizedPnl"],
                "returnOnEquity" => p["returnOnEquity"],
                "liquidationPx" => p["liquidationPx"],
                "leverage" => p["leverage"]["value"]
            }
          end)
        
        {:ok, %{
            "marginSummary" => body["marginSummary"],
            "crossMarginSummary" => body["crossMarginSummary"],
            "positions" => processed_positions
        }}

      %{"error" => error} -> {:error, error}
      _ -> {:error, "Unexpected response format from Hyperliquid"}
    end
  end
end
