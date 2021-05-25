defmodule CowinNotifier.CoWinHTTPClient do
  @moduledoc """
  Tesla Client for calling Cowin Portal API.
  """
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://cdn-api.co-vin.in")
  plug(Tesla.Middleware.Headers, [{"content-type", "application/json"}])
  plug(Tesla.Middleware.JSON)

  adapter(Tesla.Adapter.Hackney, name: __MODULE__)

  @path "/api/v2/appointment/sessions/public/calendarByDistrict"
  def get_vaccine_centers(district_id) do
    date = Calendar.strftime(Timex.today(), "%d-%m-%y")

    @path
    |> get(query: [district_id: district_id, date: date])
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}

  defp handle_response({:ok, %Tesla.Env{status: status}}), do: {:error, status}

  defp handle_response({:error, reason}), do: {:error, reason}
end
