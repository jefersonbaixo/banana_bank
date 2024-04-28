defmodule BananaBank.Factory do
  use ExMachina.Ecto, repo: BananaBank.Repo

  @cep "88037000"

  def user_factory do
    %BananaBank.Users.User{
      name: "Jane Smith",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "123455",
      cep: @cep,
      password_hash: Argon2.hash_pwd_salt("123455")
    }
  end

  def account_factory do
    %BananaBank.Accounts.Account{
      user_id: 1,
      balance: 1000
    }
  end

  def cep_factory do
    %{
      "cep" => @cep,
      "logradouro" => "Rodovia José Carlos Daux",
      "complemento" => "até 2999/3000",
      "bairro" => "João Paulo",
      "localidade" => "Florianópolis",
      "uf" => "SC",
      "ibge" => "4205407",
      "gia" => "",
      "ddd" => "48",
      "siafi" => "8105"
    }
  end
end
