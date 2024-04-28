defmodule BananaBankWeb.UsersJSON do
  alias BananaBank.Users.User

  def create(%{user: user}) do
    %{
      message: "User created with success!",
      data: data(user)
    }
  end

  def login(%{token: token}) do
    %{
      message: "User logged in with success!",
      bearer: token
    }
  end

  def delete(%{user: user}), do: %{data: data(user)}
  def get(%{user: user}), do: %{data: data(user)}
  def update(%{user: user}), do: %{message: "User updated with success!", data: data(user)}

  defp data(%User{} = user) do
    %{
      id: user.id,
      cep: user.cep,
      name: user.name,
      email: user.email
    }
  end
end
