defmodule BananaBank.Accounts.Transaction do
  alias BananaBank.Accounts
  alias Accounts.Account
  alias BananaBank.Repo
  alias Ecto.Multi

  def call(%{"value" => value}) when value <= 0, do: {:error, "value must be positive"}

  def call(%{
        "from_account_id" => from_account_id,
        "to_account_id" => to_account_id,
        "value" => value
      }) do
    with %Account{} = from_account <- Repo.get(Account, from_account_id),
         %Account{} = to_account <- Repo.get(Account, to_account_id),
         {:ok, value} <- Decimal.cast(value) do
      Multi.new()
      |> withdraw(from_account, value)
      |> insert(to_account, value)
      |> Repo.transaction()
      |> handle_result()
    else
      nil -> {:error, :not_fount}
      :error -> {:error, "invalid value"}
    end
  end

  def call(_), do: {:error, "invalid params"}

  defp withdraw(multi, from_account, value) do
    new_balance = Decimal.sub(from_account.balance, value)
    changeset = Account.changeset(from_account, %{balance: new_balance})
    Multi.update(multi, :withdraw, changeset)
  end

  defp insert(multi, to_account, value) do
    new_balance = Decimal.add(to_account.balance, value)
    changeset = Account.changeset(to_account, %{balance: new_balance})
    Multi.update(multi, :insert, changeset)
  end

  defp handle_result({:ok, _result} = result), do: result
  defp handle_result({:error, _, reason, _}), do: {:error, reason}
end
