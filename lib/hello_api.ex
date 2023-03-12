defmodule HelloApi do
  @app :hello_api

  def build_data do
    %{
      version: version(),
      env: Application.get_env(@app, :build_env),
      commit_id: Application.get_env(@app, :commit_id, "local") |> String.slice(0, 7),
      build_time: Application.get_env(@app, :build_time),
      system: System.build_info()
    }
  end

  def version do
    Application.get_env(@app, :version)
  end
end
