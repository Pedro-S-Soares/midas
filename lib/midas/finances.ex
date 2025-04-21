defmodule Midas.Finances do
  @moduledoc """
  The Finances context.
  """

  import Ecto.Query, warn: false
  alias Midas.Repo

  alias Midas.Finances.MoneySource

  @doc """
  Returns the list of money_sources.

  ## Examples

      iex> list_money_sources()
      [%MoneySource{}, ...]

  """
  def list_money_sources do
    Repo.all(MoneySource)
  end

  defdelegate get_user_money_sources(user), to: Midas.Finances.MoneySources.Search

  @doc """
  Gets a single money_source.

  Raises `Ecto.NoResultsError` if the Money source does not exist.

  ## Examples

      iex> get_money_source!(123)
      %MoneySource{}

      iex> get_money_source!(456)
      ** (Ecto.NoResultsError)

  """
  def get_money_source!(id), do: Repo.get!(MoneySource, id)

  @doc """
  Creates a money_source with its user attached.

  ## Examples

      iex> create_money_source(user_id, %{field: value})
      {:ok, %MoneySource{}}

      iex> create_money_source(user_id, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_money_source(user_id, attrs), to: Midas.Finances.MoneySources.Create

  @doc """
  Updates a money_source.

  ## Examples

      iex> update_money_source(money_source, %{field: new_value})
      {:ok, %MoneySource{}}

      iex> update_money_source(money_source, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_money_source(%MoneySource{} = money_source, attrs) do
    money_source
    |> MoneySource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a money_source.

  ## Examples

      iex> delete_money_source(money_source)
      {:ok, %MoneySource{}}

      iex> delete_money_source(money_source)
      {:error, %Ecto.Changeset{}}

  """
  def delete_money_source(%MoneySource{} = money_source) do
    Repo.delete(money_source)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking money_source changes.

  ## Examples

      iex> change_money_source(money_source)
      %Ecto.Changeset{data: %MoneySource{}}

  """
  def change_money_source(%MoneySource{} = money_source, attrs \\ %{}) do
    MoneySource.changeset(money_source, attrs)
  end
end
