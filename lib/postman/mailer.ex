defmodule Postman.Mailer do
  use Bamboo.Mailer, otp_app: :postman
  import Bamboo.Email

  @doc """
  Sends mail with the given parameters
  """
  def send_mail(to_addr, from_addr, subject, text_body, html_body) do
    new_email
    |> to(to_addr)
    |> from(from_addr)
    |> subject(subject)
    |> text_body(text_body)
    |> html_body(html_body)
    |> Postman.Mailer.deliver_later
  end
end
