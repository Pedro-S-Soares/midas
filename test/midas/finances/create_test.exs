defmodule Midas.Finances.CreateTest do
  use Midas.DataCase

  import Midas.Factory

  alias Midas.Finances.Create

  describe "create_finance/3" do
    test "returns error if user is not found" do
      # ARRANGE
      user_id = Ecto.UUID.generate()
      money_source_id = Ecto.UUID.generate()

      # ACT
      result = Create.create_finance(user_id, money_source_id, %{})

      # ASSERT
      assert {:error, "User not found"} = result
    end

    test "returns error if money source is not found" do
      # ARRANGE
      user = insert(:user)
      money_source_id = Ecto.UUID.generate()

      # ACT
      result = Create.create_finance(user.id, money_source_id, %{})

      # ASSERT
      assert {:error, "Money source not found"} = result
    end
  end

  test "returns error if user is not the owner of the money source" do
    # ARRANGE
    user = insert(:user)
    money_source = insert(:money_source)
    money_source_id = money_source.id

    # ACT
    result = Create.create_finance(user.id, money_source_id, %{})

    # ASSERT
    assert {:error, "Unauthorized"} = result
  end

  test "creates finance and updates money source current value" do
    # ARRANGE
    user = insert(:user)
    money_source = insert(:money_source, user: user, current_value: Decimal.new("1000"))

    money_source_id = money_source.id

    params = %{
      "amount" => "100",
      "title" => "Test",
      "description" => "Test description",
      "due_date" => ~U[2025-01-01 00:00:00Z]
    }

    # ACT
    {:ok, %{finance: new_finance, money_source: updated_money_source}} =
      Create.create_finance(user.id, money_source_id, params)

    # ASSERT
    assert new_finance.amount == Decimal.new("100")
    assert new_finance.title == "Test"
    assert new_finance.description == "Test description"
    assert new_finance.due_date == ~U[2025-01-01 00:00:00Z]
    assert updated_money_source.current_value == Decimal.new("1100")
  end

  test "creates finance and updates money source current value with negative amount" do
    # ARRANGE
    user = insert(:user)
    money_source = insert(:money_source, user: user, current_value: Decimal.new("1000"))

    money_source_id = money_source.id

    params = %{
      "amount" => "-100",
      "title" => "Test",
      "description" => "Test description",
      "due_date" => ~U[2025-01-01 00:00:00Z]
    }

    # ACT
    {:ok, %{finance: new_finance, money_source: updated_money_source}} =
      Create.create_finance(user.id, money_source_id, params)

    # ASSERT
    assert new_finance.amount == Decimal.new("-100")
    assert new_finance.title == "Test"
    assert new_finance.description == "Test description"
    assert new_finance.due_date == ~U[2025-01-01 00:00:00Z]
    assert updated_money_source.current_value == Decimal.new("900")
  end
end
