import Config

config :hello_api,
  build_mode: config_env(),
  build_time: DateTime.utc_now(),
  source_url: Mix.Project.config()[:source_url],
  commit_id: System.get_env("GIT_COMMIT_ID", ""),
  commit_time: System.get_env("GIT_COMMIT_TIME", "")

if config_env() == :dev do
  import_config("git_ops.exs")
end
