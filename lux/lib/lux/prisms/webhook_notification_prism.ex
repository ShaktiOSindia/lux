defmodule Lux.Prisms.WebhookNotificationPrism do
  @moduledoc """
  Sends notifications to external webhooks when events are detected.
  Includes retry logic and failure logging.
  """

  use Lux.Prism,
    name: "Webhook Notifier",
    description: "Sends a POST request to a configured webhook URL",
    input_schema: %{
      type: :object,
      properties: %{
        webhook_url: %{type: :string},
        event: %{type: :object},
        metadata: %{type: :object}
      },
      required: ["webhook_url", "event"]
    }

  def handler(input, _ctx) do
    url = input["webhook_url"]
    payload = %{
      event: input["event"],
      metadata: input["metadata"] || %{},
      timestamp: DateTime.utc_now()
    }

    # In a real PK23OS implementation, we would use Req with retry options
    case Req.post(url, json: payload, retry: :safe_transient) do
      {:ok, %{status: s}} when s in 200..299 ->
        {:ok, %{status: "delivered", code: s}}

      {:ok, %{status: s}} ->
        {:error, "Webhook returned status #{s}"}

      {:error, reason} ->
        {:error, "Failed to deliver webhook: #{inspect(reason)}"}
    end
  end
end
