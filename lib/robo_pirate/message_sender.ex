defmodule RoboPirate.MessageSender do
  require Logger

  @moduledoc """
    All messages sent go through this module.
    Each function should return with either
      {:ok, resp} or {:error, reason}
  """
  @announcemnts_id Application.get_env(:robo_pirate, :announcemnts_id)
  @send_url Application.get_env(:robo_pirate, :slack_url) <> "chat.postMessage"
  @update_url Application.get_env(:robo_pirate, :slack_url) <> "chat.update"
  @bot_token Application.get_env(:robo_pirate, :bot_token)
  @bot_headers [
    {"Content-Type", "application/json"},
    {"Authorization", "Bearer #{@bot_token}"}
  ]

  def update_message(payload) do
    HTTPoison.post(
      @update_url,
      payload |> Map.put(:token, @bot_token) |> Poison.encode!(),
      @bot_headers
    )
  end

  def send_message(text, channel) do
    Logger.info("Sending message in channel #{channel}")

    HTTPoison.post(
      @send_url,
      %{"channel" => channel, "text" => text} |> Poison.encode!(),
      @bot_headers
    )
  end

  def request_invite(params) do
    case RoboPirate.RequestInvite.encode_payload(params) do
      {:ok, payload} -> HTTPoison.post(@send_url, payload, @bot_headers)
      {:error, reason} -> {:error, reason}
    end
  end

  def new_channel(creator, channel) do
    message =
      "Ohøj kære pirater!\n" <>
        "<@#{creator}> har lige søsat kanalen <##{channel}> kig ind hvis du " <>
        "synes det lyder spændende!"

    send_message(message, @announcemnts_id)
  end

  def dont_understand(channel) do
    "Den forstod jeg ikke helt :cry:"
    |> send_message(channel)
  end
end
