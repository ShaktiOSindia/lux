defmodule Lux.Lenses.Hyperliquid.HyperliquidMarketLens do
  @moduledoc """
  A lens that fetches market metadata and asset contexts from Hyperliquid.
  Provides information about available trading pairs, prices, funding rates, and decimals.
  """

  alias Lux.Config

  use Lux.Lens,
    name: "Hyperliquid Market Info",
    description: "Fetches market metadata and asset contexts from Hyperliquid",
    method: :post,
    url: "https://api.hyperliquid.xyz/info",
    schema: %{
      type: :object,
      properties: %{},
      additionalProperties: false
    }

  def before_focus(params) do
    # Hyperliquid Info API expects the type in the body for POST requests
    Map.merge(params, %{"type" => "metaAndAssetCtxs"})
  end

  def after_focus(body) when is_list(body) do
    # Body is expected to be [universe, asset_contexts]
    [universe_meta, asset_contexts] = body
    universe = universe_meta["universe"]

    processed =
      universe
      |> Enum.with_index()
      |> Enum.map(fn {asset, idx} ->
        ctx = Enum.at(asset_contexts, idx)

        {asset["name"],
         %{
           "szDecimals" => asset["szDecimals"],
           "markPx" => ctx["markPx"],
           "midPx" => ctx["midPx"],
           "funding" => ctx["funding"],
           "openInterest" => ctx["openInterest"],
           "dayNtlVlm" => ctx["dayNtlVlm"]
         }}
      end)
      |> Map.new()

    {:ok, %{"assets" => processed}}
  end

  def after_focus(error), do: {:error, error}
end
