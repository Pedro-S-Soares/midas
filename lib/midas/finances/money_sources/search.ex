defmodule Midas.Finances.MoneySources.Search do
  alias Midas.Finances.MoneySource

  alias Midas.Repo
  import Ecto.Query

  def get_user_money_sources(user) do
    Repo.all(from m in MoneySource, where: m.user_id == ^user.id and is_nil(m.deleted_at))
  end
end
