defmodule Cashier.List do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__, as: List

  schema "lists" do
    field :name, :string
    field :properties, :map
  end

  def changeset(%List{} = list, attrs) do
    list
    |> cast(attrs, [:name, :properties])
  end
end
