defmodule Midas.Finances.MoneySources.Update do
  alias Midas.Accounts.User
  alias Midas.Finances.MoneySource
  alias Midas.Repo

  def soft_delete(user_id, money_source_id) do
    money_source = Repo.get(MoneySource, money_source_id)
    user = Repo.get(User, user_id)

    cond do
      is_nil(money_source) ->
        {:error, "Money source not found"}

      is_nil(user) ->
        {:error, "User not found"}

      money_source.user_id != user_id ->
        {:error, "User is not the owner of the money source"}

      true ->
        money_source
        |> MoneySource.changeset(%{deleted_at: DateTime.utc_now()})
        |> Repo.update()
    end
  end

  def update(user_id, money_source_id, params) do
    money_source = Repo.get(MoneySource, money_source_id)
    user = Repo.get(User, user_id)

    cond do
      is_nil(money_source) ->
        {:error, "Money source not found"}

      is_nil(user) ->
        {:error, "User not found"}

      money_source.user_id != user_id ->
        {:error, "User is not the owner of the money source"}

      true ->
        money_source
        |> MoneySource.changeset(params)
        |> Repo.update()
    end
  end
end
