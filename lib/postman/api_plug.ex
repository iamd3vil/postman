defmodule Postman.ApiPlug do
  use Plug.Router
  import Plug.Conn
  alias Postman.Parser
  alias Postman.Responder

  plug Plug.Parsers, parsers: [:urlencoded, :json],
    pass:  ["text/*"],
    json_decoder: Poison
  plug Plug.Logger
  plug :match
  plug :dispatch

  post "/api/v1/send" do
    conn.params
    |> Parser.parse()
    |> Responder.respond()
    |> case do
         :ok ->
           conn
           |> put_resp_content_type("application/json")
           |> send_resp(200, "{\"status\": \"success\"}")
         {:error, error} ->
           conn
           |> put_resp_content_type("application/json")
           |> send_resp(500, ~s({"status": "error", "error": "#{error}"}))
    end
  end

  match _ do
    conn
    |> send_resp(404, "Not Found")
  end
end
