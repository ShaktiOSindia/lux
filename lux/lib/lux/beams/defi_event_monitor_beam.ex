defmodule Lux.Beams.DeFiEventMonitorBeam do
  @moduledoc """
  The central beam for monitoring DeFi events.
  It fetches logs, decodes them, filters based on criteria, and sends notifications.
  """

  use Lux.Beam,
    name: "DeFi Event Monitor",
    description: "Monitors blockchain events and sends notifications",
    input_schema: Lux.Schemas.EventSubscriptionSchema

  alias Lux.Lenses.EVM.RPCGetLogsLens
  alias Lux.Prisms.EVM.EventDecoderPrism
  alias Lux.Prisms.EventFilterPrism
  alias Lux.Prisms.WebhookNotificationPrism
  alias Lux.Prisms.EventStorePrism
  alias Lux.Prisms.EVM.BlockTrackerPrism

  sequence do
    # 0. Get Last Block
    step(:last_block_info, BlockTrackerPrism, %{
      subscription_id: [:input, :id],
      action: "get"
    })

    # 1. Fetch Logs
    step(:raw_logs, RPCGetLogsLens, %{
      chain_id: [:input, :chain_id],
      address: [:input, :contract_address],
      fromBlock: {__MODULE__, :resolve_start_block},
      toBlock: "latest"
    })

    # 2. Decode
    step(:decoded_event, EventDecoderPrism, %{
      raw_log: [:steps, :raw_logs, :result, "logs", 0],
      abi: [:input, :abi],
      event_name: [:input, :event_name]
    })

    # 3. Filter
    step(:filter_result, EventFilterPrism, %{
      events: [[:steps, :decoded_event, :result]],
      subscription: [:input]
    })

    # 4. Notify if matches
    branch {__MODULE__, :has_matches?} do
      true ->
        step(:notify, WebhookNotificationPrism, %{
          webhook_url: [:input, :webhook_url],
          event: [:steps, :filter_result, :result, "filtered_events", 0]
        })

      false ->
        step(:log_skip, Lux.Prisms.NoOp, %{status: "no_matches"})
    end

    # 5. Persist if enabled
    branch {__MODULE__, :persistence_enabled?} do
      true ->
        step(:persist, EventStorePrism, %{
          event: [:steps, :decoded_event, :result],
          subscription_id: [:input, :id]
        })

      false ->
        step(:skip_persist, Lux.Prisms.NoOp, %{status: "persistence_disabled"})
    end

    # 6. Update Last Block
    step(:update_block, BlockTrackerPrism, %{
      subscription_id: [:input, :id],
      action: "set",
      block_number: [:steps, :raw_logs, :result, "logs", 0, "blockNumber"]
    })
  end

  def resolve_start_block(ctx) do
    last_block = get_in(ctx.steps, [:last_block_info, :result, "last_block"])
    last_block || ctx.input["from_block"] || "latest"
  end

  def has_matches?(ctx) do
    events = get_in(ctx.steps, [:filter_result, :result, "filtered_events"]) || []
    length(events) > 0
  end

  def persistence_enabled?(ctx) do
    ctx.input["persistence_enabled"] != false
  end
end
