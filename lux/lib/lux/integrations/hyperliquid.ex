defmodule Lux.Integrations.Hyperliquid do
  @moduledoc """
  Integration with the Hyperliquid API for perpetual trading and market info.
  """

  @type auth_type :: :custom
  @type api_url :: String.t()
  @type eth_key :: String.t()
  @type eth_address :: String.t()

  @doc """
  Gets the configured Hyperliquid base URL for Info API.
  """
  @spec info_url() :: String.t()
  def info_url do
    Application.get_env(:lux, :accounts)[:hyperliquid_api_url] || "https://api.hyperliquid.xyz/info"
  end

  @doc """
  Gets the configured Hyperliquid base URL for Exchange API.
  """
  @spec exchange_url() :: String.t()
  def exchange_url do
    # Usually same as info URL but can differ in some environments
    Application.get_env(:lux, :accounts)[:hyperliquid_api_url] || "https://api.hyperliquid.xyz/exchange"
  end

  @doc """
  Gets the default headers for Hyperliquid API requests.
  """
  @spec headers() :: [{String.t(), String.t()}]
  def headers do
    [
      {"content-type", "application/json"},
      {"accept", "application/json"}
    ]
  end

  @doc """
  Gets the configured Hyperliquid account's private key.
  """
  @spec private_key() :: eth_key()
  def private_key do
    Application.fetch_env!(:lux, :accounts)[:hyperliquid_private_key]
  end

  @doc """
  Gets the configured Hyperliquid account's address.
  """
  @spec address() :: eth_address()
  def address do
    Application.get_env(:lux, :accounts)[:hyperliquid_address] || ""
  end
end
