defmodule BananaBank.Users do
  alias BananaBank.Users.Verify
  alias BananaBank.Users.Create
  alias BananaBank.Users.Get
  alias BananaBank.Users.Update
  alias BananaBank.Users.Delete

  defdelegate create(params), to: Create, as: :call
  defdelegate delete(params), to: Delete, as: :call
  defdelegate get(id), to: Get, as: :call
  defdelegate update(params), to: Update, as: :call
  defdelegate login(params), to: Verify, as: :call
end
