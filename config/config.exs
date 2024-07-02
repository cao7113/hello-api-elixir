import Config

config :hello_api,
  version: Mix.Project.config()[:version],
  build_mode: config_env(),
  commit_id: System.get_env("COMMIT_ID", "local"),
  repo_url: System.get_env("REPO_URL", "unknown"),
  build_time: System.get_env("BUILD_TIME", DateTime.utc_now() |> to_string())
