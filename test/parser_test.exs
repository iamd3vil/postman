defmodule Postman.ParserTest do
  use ExUnit.Case, async: true
  alias Postman.Parser

  setup do
    email_message = %{
      "type" => "email",
      "payload" => %{
        "to" => "to@example.com",
        "subject" => "Subject",
        "text_body" => "text",
        "html_body" => "html_body"
      }
    }
    {:ok, [email_message: email_message]}
  end

  test "passing email with payload", %{email_message: email_message} do
    parsed_mesg = Parser.parse(email_message)
    assert %{type: :email, payload: {_, _, _, _}} = parsed_mesg
  end
end
