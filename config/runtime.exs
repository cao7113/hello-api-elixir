import Config

config :hello_api, test: :runtime_config_sample_value
config :hello_api, port: System.get_env("PORT", "4000")
