import Config

config :hello_api,
  version: Mix.Project.config()[:version],
  build_env: config_env(),
  commit_id: System.get_env("COMMIT_ID", "local"),
  build_time: System.get_env("BUILD_TIME", DateTime.utc_now() |> to_string())
