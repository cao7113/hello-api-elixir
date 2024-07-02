defmodule Jsoner do
  # use erlang :json instead Jason dep
  def encode!(data), do: data |> :json.encode() |> to_string
end
