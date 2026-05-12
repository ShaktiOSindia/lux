# PK23OS FULL REVENUE HARVEST VERIFICATION DOCKERFILE

FROM elixir:1.18-alpine

# Install build dependencies, Python, and Node.js
RUN apk add --no-cache build-base git python3 py3-pip nodejs npm

# Install Python dependencies
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir hyperliquid-python-sdk eth-account erlport Pillow

WORKDIR /app
COPY . .

# Remove any potentially interfering env files from the host
RUN rm -f .env .envrc test.envrc test.override.envrc dev.envrc dev.override.envrc lux/.env lux/.envrc lux/test.envrc

# Set environment variables for testing
ENV MIX_ENV=test
ENV OPENAI_API_KEY=mock_key
ENV TOGETHER_API_KEY=mock_key
ENV GOOGLE_YOUTUBE_API_KEY=mock_key
ENV HYPERLIQUID_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001
ENV HYPERLIQUID_ADDRESS=0x0000000000000000000000000000000000000001
ENV HYPERLIQUID_API_URL=https://api.hyperliquid.xyz/info
ENV WALLET_ADDRESS=0x0000000000000000000000000000000000000001
ENV WALLET_PRIVATE_KEY=0000000000000000000000000000000000000000000000000000000000000001
ENV RPC_URL=https://eth.llamarpc.com
ENV ALCHEMY_API_KEY=mock_key
ENV MIRA_API_KEY=mock_key
ENV ANTHROPIC_API_KEY=mock_key
ENV OPENWEATHER_API_KEY=mock_key
ENV TRANSPOSE_API_KEY=mock_key
ENV DISCORD_API_KEY=mock_key
ENV ETHERSCAN_API_KEY=mock_key

# Move to the lux package directory
WORKDIR /app/lux

# Install Elixir dependencies
RUN sed -i 's/{:ex_json_schema, "~> 0.10.2"}/{:ex_json_schema, "~> 0.11.0"}/' mix.exs && \
    sed -i 's/{:credo, "~> 1.7", only: \[:dev, :test\], runtime: false},//' mix.exs && \
    sed -i 's/{:dialyxir, "~> 1.4.5", only: :dev, runtime: false},//' mix.exs && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# 1. Compile
RUN mix compile

# 2. Fix and Check Format
RUN mix format && mix format --check-formatted

# 3. Run Unit Tests
CMD ["mix", "test", "test/unit/lux/lenses/youtube", "test/unit/lux/prisms/youtube", "test/unit/lux/lenses/hyperliquid", "test/unit/lux/prisms/hyperliquid"]
