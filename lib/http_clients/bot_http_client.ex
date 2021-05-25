defmodule CowinNotifier.BotHTTPClient do
  @moduledoc """
  Tesla client for calling Telegram Bot APIs.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.telegram.org")
  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  adapter(Tesla.Adapter.Hackney, name: __MODULE__)

  @path "/bot1822495834:AAGgKBkt7CbhuPi9aBNTyogyzexpGwRg9LA/sendMessage"
  @chat_id "284144917"

  def send_slot_available_msg(text) do
    @path
    |> get(query: [chat_id: @chat_id, text: text])
    |> handle_response()
  end

  def send_error_message(status) when is_integer(status) do
    @path
    |> get(query: [chat_id: @chat_id, text: "Cowin Portal API failed with status: #{status}"])
    |> handle_response()
  end

  def send_error_message(reason) do
    @path
    |> get(
      query: [
        chat_id: @chat_id,
        text: "Cowin Portal API failed with reason: #{inspect(reason)}"
      ]
    )
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status}}), do: {:error, status}
end
