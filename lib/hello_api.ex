defmodule HelloApi do
  @app :hello_api

  def build_info do
    %{
      version: vsn(),
      build_mode: Application.get_env(@app, :build_mode),
      build_time: Application.get_env(@app, :build_time) |> to_string,
      source_url: Application.get_env(@app, :source_url),
      commit_id: Application.get_env(@app, :commit_id, "") |> String.trim(),
      commit_time: Application.get_env(@app, :commit_time, "") |> parse_commit_time,
      system: System.build_info()
    }
  end

  def vsn, do: Application.spec(@app, :vsn) |> to_string()

  def parse_commit_time(""), do: nil

  def parse_commit_time(tm_str),
    do: tm_str |> String.trim() |> String.to_integer() |> DateTime.from_unix!() |> to_string()
end
