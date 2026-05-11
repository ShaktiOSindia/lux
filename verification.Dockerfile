# PK23OS BOUNTY VERIFICATION DOCKERFILE
# MISSION: Spectral-Finance/lux #82 (Hyperliquid Integration)

FROM elixir:1.17-alpine

# Install build dependencies and Python
RUN apk add --no-cache build-base git python3 py3-pip

# Install Hyperliquid Python SDK
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir hyperliquid-python-sdk eth-account erlport

WORKDIR /app
COPY . .

# Set environment variables for testing
ENV MIX_ENV=test
ENV OPENAI_API_KEY=mock_key
ENV TOGETHER_API_KEY=mock_key

# Move to the lux package directory
WORKDIR /app/lux

# Install Elixir dependencies
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

# Compile the project
RUN mix compile

# Execute the Hyperliquid Integration Tests
CMD ["mix", "test", "test/integration/hyperliquid_test.exs"]
