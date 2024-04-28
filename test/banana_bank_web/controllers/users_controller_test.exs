defmodule BananaBankWeb.UsersControllerTest do
  use BananaBankWeb.ConnCase

  alias BananaBank.ViaCep.ClientMock

  import BananaBank.Factory
  import Mox

  setup :verify_on_exit!

  describe "create/2" do
    test "successfully creates an user", %{conn: conn} do
      user = params_for(:user)

      expect(ClientMock, :call, fn _cep -> {:ok, params_for(:cep)} end)

      response =
        conn
        |> post(~p"/api/users", user)
        |> json_response(:created)

      assert response["message"] == "User created with success!"
      assert response["user"]["name"] == user["name"]
    end

    test "when there are invalid params, return an error", %{conn: conn} do
      user = params_for(:user, name: nil, cep: "1234567")

      expect(ClientMock, :call, fn _cep -> {:ok, params_for(:cep)} end)

      response =
        conn
        |> post(~p"/api/users", user)
        |> json_response(:bad_request)

      assert response == %{
               "errors" => %{
                 "cep" => ["should be 8 character(s)"],
                 "name" => ["can't be blank"]
               }
             }
    end
  end

  describe "delete/2" do
    test "successfully deletes an user", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> delete(~p"/api/users/#{user.id}", user)
        |> json_response(:ok)

      assert %{} = response
    end
  end

  describe "show/2" do
    test "successfully get a user", %{conn: conn} do
      user = insert(:user)

      response =
        conn
        |> get(~p"/api/users/#{user.id}")
        |> json_response(:ok)

      assert response["data"]["name"] == user.name
      assert response["data"]["email"] == user.email
      assert response["data"]["cep"] == user.cep
      assert response["data"]["id"] == user.id
    end
  end

  describe "update/2" do
    test "successfully updates an user", %{conn: conn} do
      user = insert(:user)
      new_name = "John Doe"

      response =
        conn
        |> put(~p"/api/users/#{user.id}", %{name: new_name})
        |> json_response(:ok)

      assert response["message"] == "User updated with success!"
      assert response["data"]["name"] == new_name
      assert response["data"]["email"] == user.email
      assert response["data"]["cep"] == user.cep
      assert response["data"]["id"] == user.id
    end
  end
end
