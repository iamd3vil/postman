defmodule Postman.ResponderTest do
  use ExUnit.Case, async: true
  use Bamboo.Test, shared: false
  import Bamboo.Email
  alias Postman.Responder

  test "test responder for email" do
    input = %{
      type: :email,
      payload: {
        "to@example.com",
        "Subject",
        "Text",
        "Html"
      }
    }
    from_addr = Application.get_env(:postman, :from_addr)
    email = new_email(
      from: from_addr,
      to: "to@example.com",
      subject: "Subject",
      text_body: "Text",
      html_body: "Html"
    )

    input
    |> Responder.respond()

    assert_delivered_email email
  end
end
