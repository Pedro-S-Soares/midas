defmodule Midas.Finances.MoneySource do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "money_sources" do
    field :name, :string
    field :description, :string
    field :current_value, :decimal
    field :deleted_at, :utc_datetime

    belongs_to :user, Midas.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(money_source, attrs) do
    money_source
    |> cast(attrs, [:current_value, :name, :description, :user_id, :deleted_at])
    |> validate_required([:current_value, :name, :user_id])
    |> validate_number(:current_value, message: "deve ser um valor numérico")
    |> foreign_key_constraint(:user_id)
  end
end
