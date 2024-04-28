defmodule BananaBank.ViaCep.ClientTest do
  use ExUnit.Case, async: true

  alias BananaBank.ViaCep.Client

  import BananaBank.Factory

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "call/1" do
    test "successfully returns cep info", %{bypass: bypass} do
      body = params_for(:cep)

      Bypass.expect(bypass, fn conn ->
        conn
        |> Plug.Conn.put_resp_content_type("application/json")
        |> Plug.Conn.send_resp(200, Jason.encode!(body))
      end)

      response =
        bypass.port
        |> endpoint_url()
        |> Client.call(body["cep"])

      assert response == {:ok, body}
    end
  end

  defp endpoint_url(port), do: "http://localhost:#{port}/"
end
