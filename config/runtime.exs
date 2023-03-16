import Config

port = System.get_env("PORT", "8080") |> String.to_integer()

config :hello_api,
  port: port
