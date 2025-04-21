defmodule Midas.Finances.MoneySources.Create do
  alias Midas.Finances.MoneySource
  alias Midas.Accounts.User

  alias Midas.Repo

  def create_money_source(user_id, attrs) do
    user = Repo.get(User, user_id)

    if user do
      %MoneySource{user_id: user_id}
      |> MoneySource.changeset(attrs)
      |> Repo.insert()
    else
      {:error, "User not found"}
    end
  end
end
