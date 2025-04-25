defmodule Midas.Finances.UpdateTest do
  use Midas.DataCase

  alias Midas.Finances.Update

  import Midas.Factory

  test "updates a finance after raising amount" do
    ## ARRANGE
    user = insert(:user)
    money_source = insert(:money_source, user: user, current_value: 1000)

    finance =
      insert(:finance,
        user: user,
        money_source: money_source,
        amount: 100,
        due_date: DateTime.utc_now()
      )

    ## ACT
    result = Update.update_finance(user.id, finance.id, %{"amount" => 200})

    ## ASSERT
    assert {:ok, %{update_finance: updated_finance, final_money_source: updated_money_source}} =
             result

    assert updated_finance.amount == Decimal.new(200)
    assert updated_money_source.current_value == Decimal.new(1200)
  end

  test "updates a finance after lowering amount" do
    ## ARRANGE
    user = insert(:user)
    money_source = insert(:money_source, user: user, current_value: 1000)

    finance =
      insert(:finance,
        user: user,
        money_source: money_source,
        amount: 100,
        due_date: DateTime.utc_now()
      )

    ## ACT
    result = Update.update_finance(user.id, finance.id, %{"amount" => 50})

    ## ASSERT
    assert {:ok, %{update_finance: updated_finance, final_money_source: updated_money_source}} =
             result

    assert updated_finance.amount == Decimal.new(50)
    assert updated_money_source.current_value == Decimal.new(1050)
  end

  test "updates a finance after changing operation type" do
    ## ARRANGE
    user = insert(:user)
    money_source = insert(:money_source, user: user, current_value: 1000)

    finance =
      insert(:finance,
        user: user,
        money_source: money_source,
        amount: 100,
        due_date: DateTime.utc_now()
      )

    ## ACT
    result = Update.update_finance(user.id, finance.id, %{"amount" => -100})

    ## ASSERT
    assert {:ok, %{update_finance: updated_finance, final_money_source: updated_money_source}} =
             result

    assert updated_finance.amount == Decimal.new(-100)
    assert updated_money_source.current_value == Decimal.new(900)
  end

  test "returns error if finance is not found" do
    ## ARRANGE
    user = insert(:user)
    finance_id = Ecto.UUID.generate()

    ## ACT
    result = Update.update_finance(user.id, finance_id, %{"amount" => 100})

    ## ASSERT
    assert {:error, "Finance not found"} = result
  end

  test "returns error if user is not the owner of the finance" do
    ## ARRANGE
    user = insert(:user)
    other_user = insert(:user)
    finance = insert(:finance, user: other_user)

    ## ACT
    result = Update.update_finance(user.id, finance.id, %{"amount" => 100})

    ## ASSERT
    assert {:error, "Unauthorized"} = result
  end
end
