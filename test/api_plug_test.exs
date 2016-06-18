defmodule Postman.ApiPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Postman.ApiPlug.init([])

  test "sending email though http api" do
    to_addr = "sarat@skorpion.tech"
    subject = "Test email"
    text_body = ""
    html_body = "<p> </p>"
    from_addr = Application.get_env(:postman, :from_addr)
    email = %{
      type: "email",
      payload: %{
        to: to_addr,
        subject: subject,
        text_body: text_body,
        html_body: html_body
      }
    }
    |> Poison.encode!

    conn = conn(:post, "/api/v1/send", email)
    |> put_req_header("content-type", "application/json")

    conn = Postman.ApiPlug.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200

  end

  test "sending email through http api with wrong parameters" do
    to_addr = "sarat@skorpion.tech"
    subject = "Test email"
    text_body = ""
    html_body = "<p> </p>"
    from_addr = Application.get_env(:postman, :from_addr)
    email = %{
      type: "email",
      payload: %{
        to: to_addr,
        subject: subject,
        text: text_body,
        html: html_body
      }
    }
    |> Poison.encode!

    conn = conn(:post, "/api/v1/send", email)
    |> put_req_header("content-type", "application/json")

    conn = Postman.ApiPlug.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 500
  end
end
