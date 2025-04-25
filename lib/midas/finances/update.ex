defmodule Midas.Finances.Update do
  alias Midas.Finances.Finance
  alias Midas.Finances.MoneySource
  alias Midas.Repo
  alias Ecto.Multi

  def update_finance(user_id, finance_id, attrs) do
    finance = Repo.get(Finance, finance_id) |> Repo.preload(:money_source)

    cond do
      is_nil(finance) ->
        {:error, "Finance not found"}

      finance.user_id != user_id ->
        {:error, "Unauthorized"}

      true ->
        Multi.new()
        |> Multi.put(:finance, finance)
        |> Multi.update(:update_finance, Finance.changeset(finance, attrs))
        |> Multi.run(:maybe_remove_amount, fn repo, %{finance: finance} ->
          if attrs["amount"] != finance.amount do
            money_source = finance.money_source

            changeset =
              MoneySource.changeset(
                money_source,
                %{current_value: Decimal.sub(money_source.current_value, finance.amount)}
              )

            repo.update(changeset)
          else
            {:ok, nil}
          end
        end)
        |> Multi.run(:final_money_source, fn repo, %{finance: finance} ->
          if attrs["amount"] != finance.amount do
            money_source = finance.money_source

            changeset =
              MoneySource.changeset(
                money_source,
                %{current_value: Decimal.add(money_source.current_value, attrs["amount"])}
              )

            repo.update(changeset)
          else
            {:ok, nil}
          end
        end)
        |> Repo.transaction()
    end
  end
end
