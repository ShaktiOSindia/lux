# Hyperliquid Integration Guide

## Overview

The Hyperliquid integration enables Lux agents to interact with the Hyperliquid perpetual exchange. It provides components for market data acquisition, position management, and autonomous risk mitigation.

## Components

### Lenses (Market & Position Sensing)
*   **HyperliquidMarketLens**: Fetches current market metadata (prices, funding rates, open interest) for all available pairs.
*   **HyperliquidPositionLens**: Retrieves real-time account state, including open positions, unrealized PnL, and liquidation prices.

### Prisms (Actions & Logic)
*   **HyperliquidMarginPrism**: Allows agents to programmatically add or remove margin from isolated positions to manage liquidation risk.
*   **HyperliquidExecuteOrderPrism**: Executes limit and trigger orders on the exchange.

### Beams (Workflows)
*   **LiquidationMonitorBeam**: A self-healing workflow that continuously monitors positions and automatically adds margin if a position's liquidation risk exceeds a defined threshold.

## Configuration

Required environment variables:

```bash
export HYPERLIQUID_PRIVATE_KEY="0x..."
export HYPERLIQUID_ADDRESS="0x..." # Your Ethereum address
export HYPERLIQUID_API_URL="https://api.hyperliquid.xyz"
```

## Example Usage

### Monitoring Positions for Risk

```elixir
alias Lux.Beams.Hyperliquid.LiquidationMonitorBeam

# Run monitor with a 80% risk threshold
{:ok, result} = LiquidationMonitorBeam.run(%{risk_threshold: 0.8})
```

## Security & Risk Control

This integration is designed with **Risk-First** principles. The `LiquidationMonitorBeam` acts as a fail-safe, ensuring that autonomous trading agents do not get liquidated during market volatility by proactively managing margin requirements.
