defmodule CowinNotifier.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: CowinNotifier.Router, options: [port: 4000]},
      CowinNotifier.Caller
    ]

    opts = [strategy: :one_for_one, name: CowinNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
