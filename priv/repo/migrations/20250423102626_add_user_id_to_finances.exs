defmodule Midas.Repo.Migrations.AddUserIdToFinances do
  use Ecto.Migration

  def change do
    alter table(:finances) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
    end

    create index(:finances, [:user_id])
  end
end
