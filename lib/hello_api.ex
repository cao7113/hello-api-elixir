defmodule HelloApi do
  def version do
    Application.get_env(:hello_api, :version)
  end
end
