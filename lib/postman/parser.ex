defmodule Postman.Parser do
  @moduledoc """
  Contains a parse function which parses the message received
  and converts into a understandable message for the responder
  """
  require Logger

  @doc """
  `parse/1` converts and validates the message received
  """
  def parse(%{"type" => "email", "payload" => payload}) do
    Logger.debug "[*] Parsing email message"
    payload
    |> parse_payload(:email)
  end

  defp parse_payload(%{"to" => to_addr, "subject" => sub, "text_body" => text, "html_body" => html}, :email) do
    %{type: :email, payload: {to_addr, sub, text, html}}
  end
  defp parse_payload(_, :email) do
    %{type: :error, error: "Invalid payload"}
  end
end
