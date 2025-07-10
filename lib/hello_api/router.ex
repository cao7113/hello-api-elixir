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
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(200, HelloApi.build_info() |> JSON.encode!())
  end

  get "/ping" do
    send_resp(conn, 200, "Pong")
  end

  get "/api/ping" do
    conn
    |> put_resp_header("location", "/ping")
    |> send_resp(
      conn.status || 302,
      """
      <html><body>
        You are being <a href=\"/ping\">redirected</a>.
      </body></html>
      """
    )
  end

  get "/hello" do
    send_resp(conn, 200, "World")
  end

  get "/users/:id" do
    send_resp(conn, 200, "Hello user##{conn.params["id"]}")
  end

  get "/inspect" do
    # proto = get_req_header(conn, "X-Forwarded-Proto")
    %Plug.Conn{req_headers: headers} = conn

    conn
    |> put_resp_content_type("text/html", "utf-8")
    |> send_resp(
      200,
      EEx.eval_string(
        """
        <html><body>
          <h1>Request Headers(on app)</h1>
          <ul>
            <%= for {k, v} <- headers do %>
            <li>
              <%=k%>: <%=v|>inspect%>
            </li>
            <%end%>
          </ul>
        </body></html>
        """,
        headers: headers
      )
    )
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Oops...")
  end
end
