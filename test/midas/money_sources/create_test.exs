defmodule Midas.MoneySources.CreateTest do
  use Midas.DataCase

  alias Midas.Factory
  alias Midas.Finances

  describe "create_money_source/2" do
    test "creates a money source" do
      # ARRANGE
      user = Factory.insert(:user)

      # ACT
      {:ok, money_source} =
        Finances.create_money_source(user.id, %{
          name: "Teste",
          description: "Teste",
          current_value: 100
        })

      # ASSERT
      assert money_source.name == "Teste"
      assert money_source.description == "Teste"
      assert money_source.current_value == Decimal.new(100)
      assert money_source.user_id == user.id
    end

    test "returns error when user is not found" do
      # ARRANGE
      user_id = Ecto.UUID.generate()

      # ACT
      result =
        Finances.create_money_source(user_id, %{
          name: "Teste",
          description: "Teste",
          current_value: 100
        })

      # ASSERT
      assert result == {:error, "User not found"}
    end
  end
end
