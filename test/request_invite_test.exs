defmodule RoboPirateTest.RequestInviteTest do
  use ExUnit.Case
  use Plug.Test

  alias RoboPirate.Router
  @opts Router.init([])

  test "Call /invite" do
    %{resp_body: raw_body} =
      conn(:post, "/invite", "")
      |> Router.call(@opts)

    assert raw_body == File.read("lib/html/error.html") |> elem(1)
  end

  test "Check that succes file is given" do
    params = %{
      "email" => "Benjamin@Rotendahl.dk",
      "info" => "Jeg er ny",
      "name" => "Benjamin@Rotendahl.dk",
      "type" => "frivillig"
    }

    %{resp_body: raw_body} =
      conn(:post, "/invite", params)
      |> Router.call(@opts)

    assert raw_body == File.read("lib/html/success.html") |> elem(1)
  end

  test "Checks that invites sends a message" do
    params = %{
      "email" => "Benjamin@Rotendahl.dk",
      "info" => "Jeg er ny",
      "name" => "Benjamin@Rotendahl.dk",
      "type" => "frivillig"
    }

    {status, %{body: encoded_resp, status_code: status_code}} =
      RoboPirate.MessageSender.request_invite(params)

    resp = Poison.decode!(encoded_resp)
    assert resp["channel"] == Application.get_env(:robo_pirate, :invite_channel)
    assert Map.has_key?(resp, "blocks")
    assert status_code == 200
    assert status == :ok
  end
end
