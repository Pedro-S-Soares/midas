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
end
