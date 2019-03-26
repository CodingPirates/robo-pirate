defmodule RoboPirateTest.RouterAction do
  use ExUnit.Case
  use Plug.Test
  alias RoboPirate.Router
  alias RoboPirateTest.MockSlackHelper
  @opts Router.init([])

  test "Test action not from slack" do
    %{status: deny, resp_body: resp} =
      conn(:post, "/action", %{Hello: "world"})
      |> Router.call(@opts)

    assert resp == "Only slack can issue actions"
    assert deny == 401
  end

  test "Check 200 response with emtpy body" do
    %{status: status, resp_body: resp} =
      conn(:post, "/action", Poison.encode!(%{}))
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 200
    assert resp == ""
  end

  test "Check 200 response for body" do
    payload =
      %{
        "payload" => Poison.encode!(%{"actions" => "hello"})
      }
      |> Poison.encode!()

    %{status: status, resp_body: resp} =
      conn(:post, "/action", payload)
      |> MockSlackHelper.add_slack_headers()
      |> Router.call(@opts)

    assert status == 200
    assert resp == ""
  end

  test "Check catch all for handle_action" do
    {status, msg} = RoboPirate.ActionHandler.handle_action(%{})
    assert status == :error
    assert msg == "Unhandled action"
  end
end
