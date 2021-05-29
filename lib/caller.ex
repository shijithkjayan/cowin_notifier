defmodule CowinNotifier.Caller do
  @moduledoc """
  Calls the `CowinNotifier.vax_centers()` evey 10 seconds.
  """
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send(self(), :call, [])
    {:ok, state}
  end

  def handle_info(:call, state) do
    CowinNotifier.vax_centers()
    |> case do
      :msg_send ->
        IO.inspect(:msg_send)
        schedule_call(2 * 60 * 60 * 000)
        {:noreply, state}

      :error ->
        IO.inspect(:error)
        schedule_call(30 * 60 * 1000)
        {:noreply, state}

      :ok ->
        IO.inspect(:ok)
        schedule_call()
        {:noreply, state}
    end
  end

  defp schedule_call(delay \\ 10000) do
    Process.send_after(self(), :call, delay)
  end

  def terminate(_, _) do
    nil
  end
end
