defmodule HelloApiTest.Router do
  # https://hexdocs.pm/ex_unit/ExUnit.Case.html
  use ExUnit.Case, async: true

  # This makes the conn object avaiable in the scope of the tests,
  # which can be used to make the HTTP request
  # https://hexdocs.pm/plug/Plug.Test.html
  # use Plug.Test
  import Plug.Test

  # We call the Plug init/1 function with the options then store
  # returned options in a Module attribute opts.
  # Note: @ is module attribute unary operator
  # https://hexdocs.pm/elixir/main/Kernel.html#@/1
  # https://hexdocs.pm/plug/Plug.html#c:init/1
  @opts HelloApi.Router.init([])

  @tag :capture_log
  test "return ok" do
    # Build a connection which is GET request on / url
    conn = conn(:get, "/ping")

    # Then call Plug.call/2 with the connection and options
    # https://hexdocs.pm/plug/Plug.html#c:call/2
    conn = HelloApi.Router.call(conn, @opts)

    # Finally we are using the assert/2 function to check for the
    # correctness of the response
    # https://hexdocs.pm/ex_unit/ExUnit.Assertions.html#assert/2
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Pong"
  end
end
