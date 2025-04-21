defmodule Midas.Repo.Migrations.AddDeletedAtToMoneySources do
  use Ecto.Migration

  def change do
    alter table(:money_sources) do
      add :deleted_at, :utc_datetime, null: true
    end

    create index(:money_sources, [:deleted_at])
  end
end
