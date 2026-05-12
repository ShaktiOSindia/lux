defmodule Lux.Lenses.EVM.RPCGetLogsLens do
  @moduledoc """
  A lens that fetches event logs directly from an EVM JSON-RPC provider.
  Supports multi-chain failover via Lux.Web3.ProviderRegistry.
  """

  alias Lux.Web3.ProviderRegistry

  use Lux.Lens,
    name: "EVM RPC Logs",
    description: "Fetches logs directly from a blockchain node",
    method: :post,
    auth: %{
      type: :custom,
      auth_function: &__MODULE__.set_rpc_url/1
    },
    schema: %{
      type: :object,
      properties: %{
        chain_id: %{type: :integer, default: 1},
        address: %{type: :string},
        fromBlock: %{type: [:integer, :string]},
        toBlock: %{type: [:integer, :string]},
        topics: %{type: :array, items: %{type: :string}}
      },
      required: ["chain_id", "fromBlock", "toBlock"]
    }

  def set_rpc_url(lens) do
    chain_id = lens.params[:chain_id] || lens.params["chain_id"] || 1

    case ProviderRegistry.get_rpc_url(chain_id) do
      nil -> raise "No RPC provider found for chain_id: #{chain_id}"
      url -> %{lens | url: url}
    end
  end

  def before_focus(params) do
    # Format for JSON-RPC eth_getLogs
    %{
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "eth_getLogs",
      "params" => [
        %{
          "address" => params[:address] || params["address"],
          "fromBlock" => format_block(params[:fromBlock] || params["fromBlock"]),
          "toBlock" => format_block(params[:toBlock] || params["toBlock"]),
          "topics" => params[:topics] || params["topics"]
        }
        |> Enum.reject(fn {_, v} -> is_nil(v) end)
        |> Map.new()
      ]
    }
  end

  def after_focus(%{"result" => logs}) when is_list(logs) do
    {:ok, %{"logs" => logs}}
  end

  def after_focus(%{"error" => %{"message" => msg}}), do: {:error, msg}
  def after_focus(error), do: {:error, "Unexpected RPC response: #{inspect(error)}"}

  defp format_block(b) when is_integer(b), do: "0x" <> Integer.to_string(b, 16)
  defp format_block(b), do: b
end
