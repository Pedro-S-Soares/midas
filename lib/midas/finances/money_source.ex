defmodule Midas.Finances.MoneySource do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "money_sources" do
    field :name, :string
    field :description, :string
    field :current_value, :decimal

    belongs_to :user, Midas.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(money_source, attrs) do
    money_source
    |> cast(attrs, [:current_value, :name, :description])
    |> validate_required([:current_value, :name, :description])
  end
end
