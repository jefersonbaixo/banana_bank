defmodule BananaBankWeb.AccountsControllerTest do
  use BananaBankWeb.ConnCase

  import BananaBank.Factory

  describe "create/2" do
    test "successfully creates an account", %{conn: conn} do
      user = insert(:user)
      account = params_for(:account, user_id: user.id)

      response =
        conn
        |> post(~p"/api/accounts", account)
        |> json_response(:created)

      assert response["message"] == "Account created with success!"
    end

    test "returns 400 when user_id is missing", %{conn: conn} do
      account = params_for(:account, user_id: nil)

      response =
        conn
        |> post(~p"/api/accounts", account)
        |> json_response(:bad_request)

      assert response == %{"errors" => %{"user_id" => ["can't be blank"]}}
    end

    test "creating a success transaction", %{conn: conn} do
      user_1 = insert(:user)
      account_1 = insert(:account, user_id: user_1.id)
      user_2 = insert(:user)
      account_2 = insert(:account, user_id: user_2.id)

      transaction = %{
        "from_account_id" => account_1.id,
        "to_account_id" => account_2.id,
        "value" => 100
      }

      response =
        conn
        |> post(~p"/api/accounts/transaction", transaction)
        |> json_response(:created)

      assert response["message"] == "Transaction completed with success!"
    end

    test "returns 400 when the transaction has invalid value", %{conn: conn} do
      user_1 = insert(:user)
      account_1 = insert(:account, user_id: user_1.id)
      user_2 = insert(:user)
      account_2 = insert(:account, user_id: user_2.id)

      transaction = %{
        "from_account_id" => account_1.id,
        "to_account_id" => account_2.id,
        "value" => "test"
      }

      response =
        conn
        |> post(~p"/api/accounts/transaction", transaction)
        |> json_response(:bad_request)

      assert response["message"] == "invalid value"
    end
  end
end
