defmodule Midas.Finances.MoneySources.Search do
  alias Midas.Finances.MoneySource

  alias Midas.Repo
  import Ecto.Query

  defp base_query(user) do
    from m in MoneySource, where: m.user_id == ^user.id and is_nil(m.deleted_at)
  end

  def get_user_money_sources(user) do
    Repo.all(base_query(user))
  end

  def get_user_money_source(user, id) do
    Repo.get(base_query(user), id)
  end
end
