defmodule Midas.FinancesFixtures do
  alias Midas.Factory

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Midas.Finances` context.
  """

  @doc """
  Generate a money_source.
  """
  def money_source_fixture(attrs \\ %{}) do
    user = Factory.insert(:user)

    attrs =
      attrs
      |> Enum.into(%{
        current_value: "120.5",
        description: "some description",
        name: "some name"
      })

    {:ok, money_source} =
      user
      |> Midas.Finances.create_money_source(attrs)

    money_source
  end
end
