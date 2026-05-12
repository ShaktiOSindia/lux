defmodule Lux.Prisms.EVM.EventDecoderPrism do
  @moduledoc """
  Decodes raw EVM logs using a provided ABI and event name.
  Provides structured data from blockchain events.
  """

  use Lux.Prism,
    name: "EVM Event Decoder",
    description: "Decodes raw EVM logs into structured data using an ABI",
    input_schema: %{
      type: :object,
      properties: %{
        raw_log: %{
          type: :object,
          properties: %{
            address: %{type: :string},
            topics: %{type: :array, items: %{type: :string}},
            data: %{type: :string},
            transactionHash: %{type: :string}
          },
          required: ["topics", "data"]
        },
        abi: %{
          type: [:string, :array],
          description: "Contract ABI or event-specific ABI"
        },
        event_name: %{
          type: :string,
          description: "Name of the event to decode"
        }
      },
      required: ["raw_log", "abi", "event_name"]
    }

  def handler(input, _ctx) do
    raw_log = input["raw_log"]
    abi = input["abi"]
    event_name = input["event_name"]

    with {:ok, abi_list} <- parse_abi(abi),
         {:ok, decoded} <- do_decode(raw_log, abi_list, event_name) do
      {:ok, decoded}
    else
      {:error, reason} -> {:error, "Decoding failed: #{reason}"}
    end
  end

  defp parse_abi(abi) when is_binary(abi), do: Jason.decode(abi)
  defp parse_abi(abi) when is_list(abi), do: {:ok, abi}
  defp parse_abi(_), do: {:error, "Invalid ABI format"}

  defp do_decode(log, abi, event_name) do
    event_spec = Enum.find(abi, &(&1["name"] == event_name && &1["type"] == "event"))

    if is_nil(event_spec) do
      {:error, "Event '#{event_name}' not found in ABI"}
    else
      # Extract types and names for decoding
      inputs = event_spec["inputs"] || []
      
      # For decoding, we separate indexed and non-indexed
      {indexed_inputs, non_indexed_inputs} = Enum.split_with(inputs, fn i -> i["indexed"] end)
      
      non_indexed_types = Enum.map(non_indexed_inputs, fn i -> i["type"] end)
      non_indexed_names = Enum.map(non_indexed_inputs, fn i -> i["name"] end)

      try do
        # Non-indexed data decoding
        data_binary = log["data"] |> String.trim_leading("0x") |> Base.decode16!(case: :mixed)
        decoded_values = ABI.decode("(#{Enum.join(non_indexed_types, ",")})", data_binary)

        # Map names to values
        params = 
          non_indexed_names 
          |> Enum.zip(decoded_values)
          |> Enum.reject(fn {name, _} -> name == "" or is_nil(name) end)
          |> Map.new()

        # In a full implementation, we'd also decode log["topics"] for indexed_inputs
        
        {:ok,
         %{
           "event" => event_name,
           "address" => log["address"],
           "transaction_hash" => log["transactionHash"],
           "block_number" => log["blockNumber"],
           "params" => params,
           "raw" => log,
           "indexed_count" => length(indexed_inputs)
         }}
      rescue
        e -> {:error, "Decoding error: #{inspect(e)}"}
      end
    end
  end
end
