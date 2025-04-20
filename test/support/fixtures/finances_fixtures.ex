defmodule Midas.FinancesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Midas.Finances` context.
  """

  @doc """
  Generate a money_source.
  """
  def money_source_fixture(attrs \\ %{}) do
    {:ok, money_source} =
      attrs
      |> Enum.into(%{
        current_value: "120.5",
        description: "some description",
        name: "some name"
      })
      |> Midas.Finances.create_money_source()

    money_source
  end
end
