defmodule RabbitmqTest do
  use ExUnit.Case, async: false
  use Bamboo.Test, shared: true
  import Bamboo.Email

  test "sending email though rabbitmq" do
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

    %{
      type: "email",
      payload: %{
        to: to_addr,
        subject: subject,
        text_body: text_body,
        html_body: html_body
      }
    }
    |> Poison.encode!
    |> send_rabbitmq_mesg

    assert_delivered_email email
  end

  defp send_rabbitmq_mesg(json) do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, "postman_queue", durable: true)
    AMQP.Basic.publish(channel, "", "postman_queue", json)
    AMQP.Connection.close(connection)
  end
end
