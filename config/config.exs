import Config

config :hello_api,
  build_mode: config_env(),
  build_time: DateTime.utc_now(),
  commit_id: System.get_env("GIT_COMMIT_ID", ""),
  commit_time: System.get_env("GIT_COMMIT_TIME", ""),
  source_url: Mix.Project.config()[:source_url]

if config_env() in [:dev] do
  import_config("#{config_env()}.exs")
end
