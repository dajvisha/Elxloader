defmodule Cashier.List do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__, as: List
  alias Cashier.Price

  schema "lists" do
    field :name, :string
    field :properties, :map

    has_many :prices, Price
  end

  def changeset(%List{} = list, attrs) do
    list
    |> cast(attrs, [:name, :properties])
  end
end
