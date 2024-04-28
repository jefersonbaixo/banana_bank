defmodule BananaBank.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset
  alias BananaBank.Accounts.Account

  @required_params [:name, :password, :email, :cep]
  @update_params [:name, :email, :cep]

  @derive {Jason.Encoder, except: [:__meta__, :password]}
  schema "users" do
    field :name, :string
    field :password, :string, virtual: true
    field :password_hash
    field :email, :string
    field :cep, :string
    has_one :account, Account

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> do_validations(@required_params)
    |> put_pass_hash()
  end

  def changeset(user, params) do
    user
    |> cast(params, @required_params)
    |> do_validations(@update_params)
    |> put_pass_hash()
  end

  defp do_validations(user, type) do
    user
    |> validate_required(type)
    |> validate_length(:name, min: 3)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:cep, is: 8)
  end

  defp put_pass_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset
end
