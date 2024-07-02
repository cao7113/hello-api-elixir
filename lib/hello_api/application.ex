defmodule HelloApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    port = Application.get_env(:hello_api, :port, 4000)
    Logger.info("server running at: http://0.0.0.0:#{port}")

    # https://hexdocs.pm/bandit/Bandit.html#t:options/0
    bandit_opts = [
      plug: HelloApi.Router,
      scheme: :http,
      port: port,
      ip: :any,
      startup_log: :debug
    ]

    children = [
      {Bandit, bandit_opts}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
