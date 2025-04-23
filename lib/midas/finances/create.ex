defmodule Midas.Finances.Create do
  alias Midas.Repo
  alias Ecto.Multi
  alias Midas.Finances.Finance

  def create_finance(user_id, money_source_id, params) do
    user = Repo.get(Midas.Accounts.User, user_id)
    money_source = Repo.get(Midas.Finances.MoneySource, money_source_id)

    cond do
      is_nil(user) ->
        {:error, "User not found"}

      is_nil(money_source) ->
        {:error, "Money source not found"}

      money_source.user_id != user_id ->
        {:error, "Unauthorized"}

      true ->
        do_create_finance(user, money_source, params)
    end
  end

  defp do_create_finance(user, money_source, params) do
    finance_changeset =
      %Finance{
        user_id: user.id,
        money_source_id: money_source.id
      }
      |> Finance.changeset(params)

    Multi.new()
    |> Multi.insert(:finance, finance_changeset)
    |> Multi.update(
      :money_source,
      Midas.Finances.MoneySource.changeset(money_source, %{
        current_value: Decimal.add(money_source.current_value, params.amount)
      })
    )
    |> Repo.transaction()
  end
end
