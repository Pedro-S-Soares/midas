defmodule Midas.FinancesTest do
  use Midas.DataCase

  alias Midas.Finances

  describe "money_sources" do
    alias Midas.Finances.MoneySource

    import Midas.FinancesFixtures

    @invalid_attrs %{name: nil, description: nil, current_value: nil}

    test "list_money_sources/0 returns all money_sources" do
      money_source = money_source_fixture()
      assert Finances.list_money_sources() == [money_source]
    end

    test "get_money_source!/1 returns the money_source with given id" do
      money_source = money_source_fixture()
      assert Finances.get_money_source!(money_source.id) == money_source
    end

    test "update_money_source/2 with valid data updates the money_source" do
      money_source = money_source_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        current_value: "456.7"
      }

      assert {:ok, %MoneySource{} = money_source} =
               Finances.update_money_source(money_source, update_attrs)

      assert money_source.name == "some updated name"
      assert money_source.description == "some updated description"
      assert money_source.current_value == Decimal.new("456.7")
    end

    test "update_money_source/2 with invalid data returns error changeset" do
      money_source = money_source_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Finances.update_money_source(money_source, @invalid_attrs)

      assert money_source == Finances.get_money_source!(money_source.id)
    end

    test "delete_money_source/1 deletes the money_source" do
      money_source = money_source_fixture()
      assert {:ok, %MoneySource{}} = Finances.delete_money_source(money_source)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_money_source!(money_source.id) end
    end

    test "change_money_source/1 returns a money_source changeset" do
      money_source = money_source_fixture()
      assert %Ecto.Changeset{} = Finances.change_money_source(money_source)
    end
  end

  describe "finances" do
    alias Midas.Finances.Finance

    import Midas.FinancesFixtures

    @invalid_attrs %{description: nil, title: nil, due_date: nil, amount: nil}

    test "list_finances/0 returns all finances" do
      finance = finance_fixture()
      assert Finances.list_finances() == [finance]
    end

    test "get_finance!/1 returns the finance with given id" do
      finance = finance_fixture()
      assert Finances.get_finance!(finance.id) == finance
    end

    test "create_finance/1 with valid data creates a finance" do
      valid_attrs = %{
        description: "some description",
        title: "some title",
        due_date: ~N[2025-04-22 00:50:00],
        amount: "120.5"
      }

      assert {:ok, %Finance{} = finance} = Finances.create_finance(valid_attrs)
      assert finance.description == "some description"
      assert finance.title == "some title"
      assert finance.due_date == ~N[2025-04-22 00:50:00]
      assert finance.amount == Decimal.new("120.5")
    end

    test "create_finance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finances.create_finance(@invalid_attrs)
    end

    test "update_finance/2 with valid data updates the finance" do
      finance = finance_fixture()

      update_attrs = %{
        description: "some updated description",
        title: "some updated title",
        due_date: ~N[2025-04-23 00:50:00],
        amount: "456.7"
      }

      assert {:ok, %Finance{} = finance} = Finances.update_finance(finance, update_attrs)
      assert finance.description == "some updated description"
      assert finance.title == "some updated title"
      assert finance.due_date == ~N[2025-04-23 00:50:00]
      assert finance.amount == Decimal.new("456.7")
    end

    test "update_finance/2 with invalid data returns error changeset" do
      finance = finance_fixture()
      assert {:error, %Ecto.Changeset{}} = Finances.update_finance(finance, @invalid_attrs)
      assert finance == Finances.get_finance!(finance.id)
    end

    test "delete_finance/1 deletes the finance" do
      finance = finance_fixture()
      assert {:ok, %Finance{}} = Finances.delete_finance(finance)
      assert_raise Ecto.NoResultsError, fn -> Finances.get_finance!(finance.id) end
    end

    test "change_finance/1 returns a finance changeset" do
      finance = finance_fixture()
      assert %Ecto.Changeset{} = Finances.change_finance(finance)
    end
  end
end
