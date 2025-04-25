defmodule Midas.Finances.Search do
  alias Midas.Repo
  import Ecto.Query

  def get_user_finances(user_id) do
    if is_nil(Repo.get(Midas.Accounts.User, user_id)) do
      {:error, "User not found"}
    else
      Repo.all(from f in Midas.Finances.Finance, where: f.user_id == ^user_id)
    end
  end

  def get_user_finance(user_id, finance_id) do
    user = Repo.get(Midas.Accounts.User, user_id)
    finance = Repo.get(Midas.Finances.Finance, finance_id)

    cond do
      is_nil(user) ->
        {:error, "User not found"}

      is_nil(finance) ->
        {:error, "Finance not found"}

      finance.user_id != user_id ->
        {:error, "Unauthorized"}

      true ->
        {:ok, finance}
    end
  end
end
