defmodule HelloApi do
  @app :hello_api

  def build_info do
    %{
      version: version(),
      build_mode: Application.get_env(@app, :build_mode),
      commit_id: Application.get_env(@app, :commit_id, "local") |> String.slice(0, 7),
      repo_url: Application.get_env(@app, :repo_url),
      build_time: Application.get_env(@app, :build_time),
      system: System.build_info()
    }
  end

  def version do
    Application.get_env(@app, :version)
  end
end
