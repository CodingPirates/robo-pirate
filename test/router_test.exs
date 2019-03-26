defmodule RoboPirateTest do
  use ExUnit.Case
  use Plug.Test
  alias RoboPirate.Router
  @opts Router.init([])

  test "Test get root / call" do
    %{resp_body: resp} =
      conn(:get, "/", "")
      |> Router.call(@opts)

    assert resp == File.read("lib/html/index.html") |> elem(1)
  end

  test "Test unhandled route" do
    %{resp_body: resp, status: status} =
      conn(:get, "/#{Faker.Address.city()}", "")
      |> Router.call(@opts)

    assert status == 404
    assert resp == "not_found"
  end

  test "Test invalid signature" do
    %{status: deny, resp_body: resp} =
      conn(:post, "/action", Poison.encode!(%{Hello: "world"}))
      |> Plug.Conn.put_req_header("content-type", "application/json")
      |> Plug.Conn.put_req_header("x-slack-signature", "v0=wrong-signature")
      |> Plug.Conn.put_req_header(
        "x-slack-request-timestamp",
        System.system_time(:second) |> Integer.to_string()
      )
      |> Router.call(@opts)

    assert resp == "Only slack can issue actions"
    assert deny == 401
  end
end
