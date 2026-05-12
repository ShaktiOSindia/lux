defmodule Lux.Schemas.EventSubscriptionSchema do
  @moduledoc """
  Schema for smart contract event monitoring subscriptions.
  Used to define what events to track, on which chain, and where to send notifications.
  """

  use Lux.SignalSchema,
    name: "event_subscription",
    version: "1.0.0",
    description: "Defines a subscription to smart contract events",
    schema: %{
      type: :object,
      properties: %{
        id: %{
          type: :string,
          description: "Unique identifier for the subscription"
        },
        chain_id: %{
          type: :integer,
          description: "EVM Chain ID (e.g., 1 for Ethereum, 137 for Polygon)",
          default: 1
        },
        contract_address: %{
          type: :string,
          description: "The address of the smart contract to monitor",
          pattern: "^0x[a-fA-F0-9]{40}$"
        },
        event_name: %{
          type: :string,
          description: "The name of the event to monitor (e.g., 'Transfer')"
        },
        abi: %{
          type: [:string, :object, :array],
          description: "The ABI of the contract or the specific event to enable decoding"
        },
        filters: %{
          type: :object,
          description: "Optional filters for event parameters",
          additionalProperties: true
        },
        webhook_url: %{
          type: :string,
          description: "URL to send POST notifications when events are detected"
        },
        from_block: %{
          type: [:integer, :string],
          description: "Start syncing from this block (number or 'latest')"
        },
        persistence_enabled: %{
          type: :boolean,
          description: "Whether to store events in the OS's ACID substrate for replay",
          default: true
        }
      },
      required: ["id", "chain_id", "contract_address", "event_name", "abi"],
      additionalProperties: false
    }
end
