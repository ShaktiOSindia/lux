defmodule Lux.Prisms.EVM.BlockTrackerPrism do
  @moduledoc """
  Tracks the last processed block for a given subscription.
  Ensures that the monitor picks up where it left off.
  """

  use Lux.Prism,
    name: "Block Tracker",
    description: "Gets or sets the last processed block for a subscription",
    input_schema: %{
      type: :object,
      properties: %{
        subscription_id: %{type: :string},
        action: %{type: :string, enum: ["get", "set"]},
        block_number: %{type: :integer}
      },
      required: ["subscription_id", "action"]
    }

  def handler(input, _ctx) do
    sub_id = input["subscription_id"]
    action = input["action"]

    memory_name = :block_tracker_memory
    
    # Initialize global block tracker memory if not exists
    case Process.whereis(memory_name) do
      nil -> Lux.Memory.SimpleMemory.initialize(name: memory_name)
      pid -> pid
    end

    case action do
      "get" ->
        {:ok, entries} = Lux.Memory.SimpleMemory.recent(memory_name, 100)
        # Find the latest entry for this sub_id
        last_block = 
          entries 
          |> Enum.find(fn e -> e.metadata[:subscription_id] == sub_id end)
          |> case do
            nil -> nil
            e -> e.content
          end
        {:ok, %{"last_block" => last_block}}

      "set" ->
        block = input["block_number"]
        Lux.Memory.SimpleMemory.add(memory_name, block, :system, %{subscription_id: sub_id})
        {:ok, %{"status" => "updated", "block" => block}}
    end
  end
end
