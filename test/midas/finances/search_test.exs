defmodule Midas.Finances.SearchTest do
  use Midas.DataCase

  alias Midas.Finances.Search
  import Midas.Factory

  describe "get_user_finances/1" do
    test "returns all finances for a given user" do
      ## ARRANGE
      user = insert(:user)
      _finances = insert_list(3, :finance, user: user)
      _other_user_finances = insert_list(10, :finance)

      ## ACT
      finances = Search.get_user_finances(user.id)

      ## ASSERT
      assert length(finances) == 3
    end

    test "returns an empty list if the user has no finances" do
      ## ARRANGE
      user = insert(:user)

      ## ACT
      finances = Search.get_user_finances(user.id)

      ## ASSERT
      assert length(finances) == 0
      assert is_list(finances)
    end

    test "returns error if user is not found" do
      ## ARRANGE
      user_id = Ecto.UUID.generate()

      ## ACT
      result = Search.get_user_finances(user_id)

      ## ASSERT
      assert {:error, "User not found"} = result
    end
  end

  describe "get_user_finance/2" do
    test "returns the finance for a given user" do
      ## ARRANGE
      user = insert(:user)
      finance = insert(:finance, user: user)

      ## ACT
      result = Search.get_user_finance(user.id, finance.id)

      ## ASSERT
      assert {:ok, found_finance} = result
      assert found_finance.id == finance.id
    end

    test "returns error if user is not found" do
      ## ARRANGE
      user_id = Ecto.UUID.generate()

      ## ACT
      result = Search.get_user_finance(user_id, Ecto.UUID.generate())

      ## ASSERT
      assert {:error, "User not found"} = result
    end

    test "returns error if finance is not found" do
      ## ARRANGE
      user = insert(:user)
      finance_id = Ecto.UUID.generate()

      ## ACT
      result = Search.get_user_finance(user.id, finance_id)

      ## ASSERT
      assert {:error, "Finance not found"} = result
    end

    test "returns error if user is not the owner of the finance" do
      ## ARRANGE
      user = insert(:user)
      other_user = insert(:user)
      finance = insert(:finance, user: other_user)

      ## ACT
      result = Search.get_user_finance(user.id, finance.id)

      ## ASSERT
      assert {:error, "Unauthorized"} = result
    end
  end
end
