defmodule Postman.ApiPlug do
  use Plug.Router
  import Plug.Conn

  plug Plug.Parsers, parsers: [:urlencoded, :json],
    pass:  ["text/*"],
    json_decoder: Poison
  plug Plug.Logger
  plug :match
  plug :dispatch

  post "/api/v1/sendmail" do
    %{
      "to" => to_addr,
      "subject" => sub,
      "text_body" => text,
      "html_body" => html
    } = conn.params

    # Getting `from address` from config
    from_addr = Application.get_env(:postman, :from_addr)

    Postman.Mailer.send_mail(to_addr, from_addr, sub, text, html)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "{\"status\": \"OK\"}")
  end

  match _ do
    conn
    |> send_resp(404, "Not Found")
  end
end
