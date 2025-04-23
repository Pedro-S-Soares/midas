defmodule Midas.Finances.Search do
  alias Midas.Repo
  import Ecto.Query

  def get_user_finances(user_id) do
    if is_nil(Repo.get(Midas.Accounts.User, user_id)) do
      {:error, "User not found"}
    else
      Repo.all(from f in Midas.Finances.Finance, where: f.user_id == ^user_id)
    end
  end
end
