defmodule BananaBank.Users.Verify do
  alias BananaBank.Users

  def call(%{"id" => id, "password" => password}) do
    case Users.get(id) do
      {:ok, user} -> verify(user, password)
      {:error, _} -> {:error, :not_found}
    end
  end

  defp verify(user, password) do
    case Argon2.verify_pass(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, :unauthorized}
    end
  end
end
