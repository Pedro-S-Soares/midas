defmodule Midas.MoneySources.SearchTest do
  use Midas.DataCase

  alias Midas.Finances.MoneySources.Search
  alias Midas.Factory

  describe "get_user_money_sources/1" do
    test "returns the user's money sources" do
      # ARRANGE
      user = Factory.insert(:user)
      money_source = Factory.insert(:money_source, user: user)

      # ACT
      result = Search.get_user_money_sources(user)

      # ASSERT
      assert length(result) == 1
      assert result |> List.first() |> Map.get(:id) == money_source.id
    end
  end
end
