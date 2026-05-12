defmodule Lux.Prisms.Hyperliquid.HyperliquidMarginPrism do
  @moduledoc """
  A prism that manages isolated margin for Hyperliquid positions.
  Can be used to add or remove margin from an open position to adjust liquidation price.
  """

  use Lux.Prism,
    name: "Hyperliquid Margin Management",
    description: "Adds or removes margin from isolated positions on Hyperliquid",
    input_schema: %{
      type: :object,
      properties: %{
        coin: %{
          type: :string,
          description: "Trading pair symbol (e.g., 'ETH', 'BTC')"
        },
        is_buy: %{
          type: :boolean,
          description: "True if managing a long position, false for short"
        },
        ntli: %{
          type: :number,
          description: "Margin amount to add (positive) or remove (negative) in USD"
        }
      },
      required: ["coin", "is_buy", "ntli"]
    },
    output_schema: %{
      type: :object,
      properties: %{
        status: %{type: :string},
        result: %{type: :object}
      },
      required: ["status", "result"]
    }

  import Lux.Python

  alias Lux.Config

  require Lux.Python

  def handler(input, _ctx) do
    with {:ok, private_key} <- get_private_key(),
         {:ok, address} <- {:ok, Config.hyperliquid_account_address()},
         {:ok, api_url} <- {:ok, Config.hyperliquid_api_url()},
         {:ok, %{"success" => true}} <- Lux.Python.import_package("hyperliquid.exchange"),
         {:ok, %{"success" => true}} <- Lux.Python.import_package("hyperliquid_utils.setup"),
         {:ok, result} <- update_margin(private_key, address, api_url, input) do
      {:ok, %{status: "success", result: result}}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp get_private_key do
    {:ok, Config.hyperliquid_account_key()}
  rescue
    RuntimeError -> {:error, "Hyperliquid account private key is not configured"}
  end

  defp update_margin(private_key, address, api_url, params) do
    python_result =
      python variables: %{
               private_key: private_key,
               address: address,
               api_url: api_url,
               params: params
             } do
        ~PY"""
        from hyperliquid_utils.setup import setup

        address, info, exchange = setup(private_key, address, api_url, skip_ws=True)

        # Hyperliquid expect margin in raw units (amount * 1e6)
        # Note: ntli is the integer margin change in USD * 1e6
        margin_result = exchange.update_isolated_margin(
            params["ntli"],
            params["coin"]
        )

        margin_result
        """
      end

    case python_result do
      %{"error" => error} -> {:error, error}
      result when is_map(result) -> {:ok, result}
    end
  end
end
