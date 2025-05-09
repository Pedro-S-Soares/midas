defmodule Midas.Repo.Migrations.CreateMoneySources do
  use Ecto.Migration

  def change do
    create table(:money_sources, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :current_value, :decimal
      add :name, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:money_sources, [:user_id])
  end
end
