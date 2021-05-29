defmodule CowinNotifier.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: CowinNotifier.Endpoint,
        options: [port: Application.get_env(:cowin_notifier, :port)]
      ),
      CowinNotifier.Caller
    ]

    opts = [strategy: :one_for_one, name: CowinNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
