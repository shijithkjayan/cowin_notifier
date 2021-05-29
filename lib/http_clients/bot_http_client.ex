defmodule CowinNotifier.BotHTTPClient do
  @moduledoc """
  Tesla client for calling Telegram Bot APIs.
  """
  use Tesla
  alias CowinNotifier.CoWinHTTPClient

  plug(Tesla.Middleware.BaseUrl, "https://api.telegram.org")
  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Timeout, timeout: 15_000)
  adapter(Tesla.Adapter.Hackney, name: __MODULE__)

  @path "/bot1822495834:AAGgKBkt7CbhuPi9aBNTyogyzexpGwRg9LA/sendMessage"
  @chat_id "284144917"

  def send_slot_available_msg(text) do
    @path
    |> get(query: [chat_id: @chat_id, text: text])
    |> CoWinHTTPClient.handle_response()
  end

  def send_error_message(status) when is_integer(status) do
    user = System.user_home()

    @path
    |> get(
      query: [
        chat_id: @chat_id,
        text: "Cowin Portal API failed with status: #{status} | User: user"
      ]
    )
    |> CoWinHTTPClient.handle_response()
  end

  def send_error_message(reason) do
    @path
    |> get(
      query: [
        chat_id: @chat_id,
        text: "Cowin Portal API failed with reason: #{inspect(reason)}"
      ]
    )
    |> CoWinHTTPClient.handle_response()
  end
end
