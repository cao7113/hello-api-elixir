import Config

config :hello_api,
  build_mode: config_env(),
  build_time: DateTime.utc_now(),
  commit_id: System.get_env("GIT_COMMIT_ID", ""),
  commit_time: System.get_env("GIT_COMMIT_TIME", ""),
  repo_url: System.get_env("REPO_URL", "https://github.com/cao7113/hello-api-elixir")

# import_config "#{config_env()}.exs"
