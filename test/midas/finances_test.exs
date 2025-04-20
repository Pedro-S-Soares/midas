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

    test "create_money_source/1 with valid data creates a money_source" do
      valid_attrs = %{name: "some name", description: "some description", current_value: "120.5"}

      assert {:ok, %MoneySource{} = money_source} = Finances.create_money_source(valid_attrs)
      assert money_source.name == "some name"
      assert money_source.description == "some description"
      assert money_source.current_value == Decimal.new("120.5")
    end

    test "create_money_source/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finances.create_money_source(@invalid_attrs)
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
end
