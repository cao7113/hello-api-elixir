defmodule HelloApi.Router do
  # https://hexdocs.pm/plug/Plug.Router.html
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  # # Once there is a match, parse the response body if the content-type
  # # is application/json. The order is important here, as we only want to
  # # parse the body if there is a matching route.(Using the Jayson parser)
  # plug(Plug.Parsers,
  #   parsers: [:json],
  #   pass: ["application/json"],
  #   json_decoder: Jason
  # )

  # Dispatch the connection to the matched handler
  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Ok!")
  end

  get "/ping" do
    send_resp(conn, 200, "Pong")
  end

  get "/hello" do
    send_resp(conn, 200, "World")
  end

  get "/info" do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, HelloApi.build_info() |> Jsoner.encode!())
  end

  get "/users/:id" do
    send_resp(conn, 200, "Hello user##{conn.params["id"]}")
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Oops...")
  end
end
