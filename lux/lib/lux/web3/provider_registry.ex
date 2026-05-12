defmodule Lux.Web3.ProviderRegistry do
  @moduledoc """
  A registry for blockchain RPC providers across different chains.
  Handles failover and retrieval of RPC URLs.
  """

  @default_providers %{
    1 => ["https://eth.llamarpc.com", "https://rpc.ankr.com/eth"],
    137 => ["https://polygon-rpc.com", "https://rpc.ankr.com/polygon"],
    42161 => ["https://arb1.arbitrum.io/rpc", "https://rpc.ankr.com/arbitrum"],
    10 => ["https://mainnet.optimism.io", "https://rpc.ankr.com/optimism"],
    8453 => ["https://mainnet.base.org", "https://rpc.ankr.com/base"]
  }

  @doc """
  Returns a list of RPC URLs for a given chain ID.
  Prioritizes configured RPCs over defaults.
  """
  def get_providers(chain_id) do
    configured = get_configured_providers(chain_id)
    defaults = Map.get(@default_providers, chain_id, [])

    (configured ++ defaults)
    |> Enum.uniq()
    |> Enum.reject(&(&1 == "" || is_nil(&1)))
  end

  @doc """
  Returns the best available RPC URL for a given chain ID.
  """
  def get_rpc_url(chain_id) do
    case get_providers(chain_id) do
      [primary | _] -> primary
      [] -> nil
    end
  end

  defp get_configured_providers(chain_id) do
    # Check Application env for :lux, :rpc_providers, chain_id
    :lux
    |> Application.get_env(:rpc_providers, [])
    |> Keyword.get(chain_id, [])
    |> List.wrap()
  end
end
