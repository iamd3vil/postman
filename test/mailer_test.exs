defmodule MailerTest do
  use ExUnit.Case, async: true
  use Bamboo.Test
  import Bamboo.Email

  test "sending mail" do
    to_addr = "sarat@skorpion.tech"
    subject = "Test email"
    text_body = ""
    html_body = "<p> </p>"
    from_addr = Application.get_env(:postman, :from_addr)
    email = new_email(
      from: from_addr,
      to: to_addr,
      subject: subject,
      text_body: text_body,
      html_body: html_body
    )
    Postman.Mailer.send_mail(to_addr, from_addr, subject, text_body, html_body)
    assert_delivered_email email
  end
end
