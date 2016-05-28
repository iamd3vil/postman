defmodule Postman.RabbitmqWorker do
  @moduledoc """
  This is a genserver which acts as a rabbitmq
  worker and when receives a message, acts accroding
  to the message
  """
  use GenServer
  use AMQP
  require Logger

  @exchange "postman_exchange"
  @queue "postman_queue"

  def start_link(conn) do
    GenServer.start_link(__MODULE__, conn, [])
  end

  def init(conn) do
    {:ok, chan} = Channel.open(conn)
    # Limit unacknowledged messages to 1
    Basic.qos(chan, prefetch_count: 1)
    Queue.declare(chan, @queue, durable: true)
    {:ok, _consumer_tag} = Basic.consume(chan, @queue)
    {:ok, chan}
  end

  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    Logger.debug "[*] Basic Consume OK"
    {:noreply, chan}
  end

  @doc """
  Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  """
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  @doc """
  Confirmation sent by the broker to the consumer process after a Basic.cancel
  """
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag}}, chan) do
    spawn fn -> consume(chan, tag, payload) end
    {:noreply, chan}
  end

  defp consume(channel, tag, payload) do
    Basic.ack channel, tag
    Logger.debug "[*] Received payload: #{payload}"
    with {:ok, payload_decoded} <- Poison.decode(payload),
    do: parse(payload_decoded)
  end

  defp parse(%{"to_email" => to_email, "subject" => subject, "text_body" => text, "html_body" => html}) do
    from_addr = Application.get_env(:postman, :from_addr)
    Postman.Mailer.send_mail(to_email, from_addr, subject, text, html)
  end
end
