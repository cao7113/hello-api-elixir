defmodule HelloApi do
  # @app :hello_api
  # def app, do: @app
  def app, do: Application.get_application(__MODULE__)

  def vsn, do: Application.spec(app(), :vsn) |> to_string()
  def source_url, do: Application.get_env(app(), :source_url)
  def build_mode, do: Application.get_env(app(), :build_mode)
  def build_time, do: Application.get_env(app(), :build_time) |> to_string

  def build_info do
    %{
      app: app(),
      version: vsn(),
      source_url: source_url(),
      build_mode: build_mode(),
      build_time: build_time(),
      system: System.build_info(),
      commit: commit()
    }
  end

  # put into standalone hex pkg?
  def commit do
    %{
      commit_id: Application.get_env(app(), :commit_id, "") |> String.trim(),
      commit_time: Application.get_env(app(), :commit_time, "") |> parse_commit_time
    }
  end

  def parse_commit_time(""), do: nil

  def parse_commit_time(tm_str),
    do: tm_str |> String.trim() |> String.to_integer() |> DateTime.from_unix!() |> to_string()
end
