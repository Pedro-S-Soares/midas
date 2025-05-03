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
        |> Multi.put(:finance, finance |> Repo.preload(:money_source))
        |> Multi.run(:new_money_source, fn repo, %{finance: finance} ->
          if attrs["money_source_id"] != finance.money_source_id and
               !is_nil(attrs["money_source_id"]) do
            {:ok, repo.get(MoneySource, attrs["money_source_id"])}
          else
            {:ok, nil}
          end
        end)
        |> Multi.update(:update_finance, Finance.changeset(finance, attrs))
        |> Multi.run(:update_money_source, fn repo,
                                              %{
                                                new_money_source: new_money_source,
                                                finance: finance,
                                                update_finance: update_finance
                                              } ->
          cond do
            is_nil(new_money_source) and finance.amount == update_finance.amount ->
              {:ok, nil}

            is_nil(new_money_source) and finance.amount != update_finance.amount ->
              new_amount = update_finance.amount
              old_amount = finance.amount

              money_source_new_value =
                Decimal.sub(finance.money_source.current_value, old_amount)
                |> Decimal.add(new_amount)

              repo.update(
                MoneySource.changeset(finance.money_source, %{
                  current_value: money_source_new_value
                })
              )

            true ->
              old_amount = finance.amount
              money_source_new_value = Decimal.sub(finance.money_source.current_value, old_amount)

              repo.update(
                MoneySource.changeset(finance.money_source, %{
                  current_value: money_source_new_value
                })
              )
          end
        end)
        |> Multi.run(:update_new_money_source, fn repo,
                                                  %{
                                                    new_money_source: new_money_source,
                                                    update_finance: update_finance
                                                  } ->
          if !is_nil(new_money_source) do
            {:ok,
             repo.update(
               MoneySource.changeset(new_money_source, %{
                 current_value: Decimal.add(new_money_source.current_value, update_finance.amount)
               })
             )}
          else
            {:ok, nil}
          end
        end)
        |> Repo.transaction()
    end
  end
end
