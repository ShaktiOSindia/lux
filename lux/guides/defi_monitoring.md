# DeFi Event Monitoring Guide

## Overview
The DeFi Event Monitoring System allows Lux agents to track, parse, and react to smart contract events across multiple EVM chains and protocols (including Hyperliquid).

## Core Components

### 1. Subscription Schema
Use `Lux.Schemas.EventSubscriptionSchema` to define what you want to track.
Example:
```elixir
subscription = %{
  id: "univ3-large-swap",
  chain_id: 1,
  contract_address: "0x...",
  event_name: "Swap",
  abi: [...],
  filters: %{"amount0" => %{"gt" => 1000000000000000000}},
  webhook_url: "https://my-api.com/webhooks/defi"
}
```

### 2. Event Ingestion (Direct RPC)
The `Lux.Lenses.EVM.RPCGetLogsLens` provides sovereign access to blockchain data without relying on Etherscan. It uses the `Lux.Web3.ProviderRegistry` to handle automatic failover between RPC nodes.

### 3. Processing Pipeline
- **Decoder**: `Lux.Prisms.EVM.EventDecoderPrism` converts raw hex logs into human-readable maps.
- **Filter**: `Lux.Prisms.EventFilterPrism` applies your custom logic (e.g., "only alerts for swaps > 10 ETH").

## Running the Monitoring Beam

The `DeFiEventMonitorBeam` orchestrates the entire flow:
1. Fetch Logs via RPC.
2. Decode Logs using ABI.
3. Filter Logs against Subscription.
4. Notify via Webhook.

## Excellence Standards
- **Sovereignty**: Uses direct JSON-RPC calls.
- **Resilience**: Auto-failover between RPC providers.
- **Integrity**: Every event can be cross-verified by the Independent Auditor.
