defmodule Midas.Finances.MoneySources.UpdateTest do
  use Midas.DataCase

  import Midas.Factory

  describe "soft_delete/2" do
    test "soft deletes a money source" do
      # ARRANGE
      user = insert(:user)
      money_source = insert(:money_source, user: user)

      # ACT
      assert result = Midas.Finances.MoneySources.Update.soft_delete(user.id, money_source.id)

      # ASSERT
      assert {:ok, money_source} = result
      assert money_source.deleted_at
    end

    test "returns an error if the money source is not found" do
      # ARRANGE
      user = insert(:user)
      money_source_id = Ecto.UUID.generate()

      # ACT
      assert {:error, "Money source not found"} =
               Midas.Finances.MoneySources.Update.soft_delete(user.id, money_source_id)
    end

    test "returns an error if the user is not found" do
      # ARRANGE
      user_id = Ecto.UUID.generate()
      money_source = insert(:money_source)

      # ACT
      assert {:error, "User not found"} =
               Midas.Finances.MoneySources.Update.soft_delete(user_id, money_source.id)
    end

    test "returns an error if the user is not the owner of the money source" do
      # ARRANGE
      user = insert(:user)
      money_source = insert(:money_source)

      # ACT
      assert {:error, "User is not the owner of the money source"} =
               Midas.Finances.MoneySources.Update.soft_delete(user.id, money_source.id)
    end
  end
end
