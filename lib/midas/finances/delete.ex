defmodule Midas.Finances.Delete do
  alias Midas.Repo
  alias Ecto.Multi
  alias Midas.Finances.Finance
  alias Midas.Finances.MoneySource

  def delete_finance(user_id, finance_id) do
    finance = Repo.get(Finance, finance_id)

    cond do
      is_nil(finance) ->
        {:error, "Finance not found"}

      finance.user_id != user_id ->
        {:error, "Unauthorized"}

      true ->
        do_delete_finance(finance)
    end
  end

  defp do_delete_finance(finance) do
    money_source = Repo.preload(finance, :money_source).money_source

    Multi.new()
    |> Multi.delete(:finance, finance)
    |> Multi.put(:money_source, money_source)
    |> Multi.update(:updated_money_source, fn %{money_source: money_source} ->
      attrs = %{current_value: Decimal.sub(money_source.current_value, finance.amount)}
      MoneySource.changeset(money_source, attrs)
    end)
    |> Repo.transaction()
  end
end
