defmodule CowinNotifier do
  @moduledoc """
  Documentation for `CowinNotifier`.
  """
  alias CowinNotifier.{BotHTTPClient, CoWinHTTPClient}

  @doc """
  Calls the Cowin Portal API and fetches the
  vaccination centers in Malappuram District of
  Kerala, India. Then filters out the centers with
  avaialbe slots for people of age 18+ and sends
  a telegram message with center details if slots are available.
  Then returns `:msg_send`.
  Returns `:ok` if no slots are available.
  Reurns `:error` for other cases.

  ## Examples

      iex> CowinNotifier.vax_centers()
      :msg_send

      iex> CowinNotifier.vax_centers()
      :ok

      iex> CowinNotifier.vax_centers()
      :error

  """

  def vax_centers() do
    CoWinHTTPClient.get_vaccine_centers(302)
    |> case do
      {:ok, %{"centers" => centers}} ->
        text_list =
          centers
          |> Enum.filter(&check_conditions(&1, 18))
          |> Enum.map(&stringify_centers/1)

        if text_list != [] do
          BotHTTPClient.send_slot_available_msg(text_list)
          :msg_send
        else
          :ok
        end

      {:error, reason} ->
        BotHTTPClient.send_error_message(reason)
        :error
    end
  end

  defp check_conditions(
         %{"sessions" => [%{"available_capacity" => capacity, "min_age_limit" => age}]} = center,
         age
       )
       when capacity > 0,
       do: center

  defp check_conditions(_, _), do: nil

  defp stringify_centers(
         %{
           "sessions" => [
             %{"available_capacity" => capacity, "vaccine" => vaccine, "slots" => slots}
           ]
         } = center
       ) do
    """
    #{center["name"]}

    Avaialbe capacity: #{capacity}

    Vaccine: #{vaccine}

    Slots: #{Enum.join(slots, ",")}

    Address: #{center["address"]}

    ----------------------------------------

    """
  end
end
