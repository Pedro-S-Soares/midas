defmodule Midas.Finances.Finance do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "finances" do
    field :description, :string
    field :title, :string
    field :due_date, :utc_datetime
    field :amount, :decimal

    belongs_to :money_source, Midas.Finances.MoneySource
    belongs_to :user, Midas.Accounts.User
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(finance, attrs) do
    finance
    |> cast(attrs, [:title, :description, :due_date, :amount, :money_source_id, :user_id])
    |> validate_required([:title, :due_date, :amount, :money_source_id, :user_id])
  end
end
