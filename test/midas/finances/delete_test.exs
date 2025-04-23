defmodule Midas.Finances.DeleteTest do
  use Midas.DataCase

  alias Midas.Finances.Delete
  alias Midas.Finances.Finance
  alias Midas.Finances.MoneySource

  import Midas.Factory

  describe "delete_finance/2" do
    test "deletes a finance and updates the money source balance" do
      ## ARRANGE
      user = insert(:user)
      money_source = insert(:money_source, user: user, current_value: Decimal.new(100))
      finance = insert(:finance, user: user, money_source: money_source, amount: Decimal.new(10))

      ## ACT
      assert {:ok, _} = Delete.delete_finance(user.id, finance.id)

      ## ASSERT
      refute Repo.get(Finance, finance.id)
      assert Repo.get(MoneySource, money_source.id).current_value == Decimal.new(90)
    end

    test "returns an error if the finance is not found" do
      ## ARRANGE
      user = insert(:user)

      ## ACT
      assert {:error, "Finance not found"} = Delete.delete_finance(user.id, Ecto.UUID.generate())
    end

    test "returns an error if the user is not the owner of the finance" do
      ## ARRANGE
      user = insert(:user)
      other_user = insert(:user)
      money_source = insert(:money_source, user: user, current_value: Decimal.new(100))

      finance =
        insert(:finance, user: other_user, money_source: money_source, amount: Decimal.new(10))

      ## ACT
      assert {:error, "Unauthorized"} = Delete.delete_finance(user.id, finance.id)
    end
  end
end
