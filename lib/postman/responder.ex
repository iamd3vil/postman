defmodule Postman.Responder do

  def respond(%{type: :email, payload: {to_addr, sub, text, html}}) do
    # Getting `from address` from config
    from_addr = Application.get_env(:postman, :from_addr)

    Postman.Mailer.send_mail(to_addr, from_addr, sub, text, html)
    :ok
  end
  def respond(%{type: :error, error: error}) do
    {:error, error}
  end
end
