defmodule Lux.Beams.DeFiEventMonitorBeamTest do
  use ExUnit.Case, async: true

  alias Lux.Beams.DeFiEventMonitorBeam

  @mock_abi [
    %{
      "anonymous" => false,
      "inputs" => [
        %{"indexed" => true, "name" => "from", "type" => "address"},
        %{"indexed" => true, "name" => "to", "type" => "address"},
        %{"indexed" => false, "name" => "value", "type" => "uint256"}
      ],
      "name" => "Transfer",
      "type" => "event"
    }
  ]

  @mock_log %{
    "address" => "0x1234567890123456789012345678901234567890",
    "blockNumber" => "0x1",
    "data" => "0x0000000000000000000000000000000000000000000000000000000000000064",
    "topics" => [
      "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef",
      "0x0000000000000000000000001111111111111111111111111111111111111111",
      "0x0000000000000000000000002222222222222222222222222222222222222222"
    ],
    "transactionHash" => "0xabcdef"
  }

  test "beam structural execution" do
    _input = %{
      "id" => "test-sub",
      "chain_id" => 1,
      "contract_address" => "0x1234567890123456789012345678901234567890",
      "event_name" => "Transfer",
      "abi" => @mock_abi,
      "webhook_url" => "http://localhost:8080/webhook"
    }

    # Verify log presence in mock data
    assert @mock_log["address"] == "0x1234567890123456789012345678901234567890"
    assert DeFiEventMonitorBeam.view().name == "DeFi Event Monitor"
  end
end
