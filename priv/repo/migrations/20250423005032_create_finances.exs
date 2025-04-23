defmodule Midas.Repo.Migrations.CreateFinances do
  use Ecto.Migration

  def change do
    create table(:finances, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :due_date, :utc_datetime
      add :amount, :decimal
      add :money_source_id, references(:money_sources, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:finances, [:money_source_id])
  end
end
