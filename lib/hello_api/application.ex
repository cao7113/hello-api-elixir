defmodule HelloApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:hello_api, :port, 8080)
    Logger.info("server running at: http://0.0.0.0:#{port}")

    children = [
      # Starts a worker by calling: HelloApi.Worker.start_link(arg)
      # {HelloApi.Worker, arg}
      {
        Plug.Cowboy,
        scheme: :http,
        plug: HelloApi.Router,
        options: [
          # ip: {0, 0, 0, 0},
          port: port
        ]
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
