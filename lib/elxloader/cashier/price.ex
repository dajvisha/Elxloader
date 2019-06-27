defmodule Cashier.Price do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__, as: Price
  alias Cashier.{List, Item}

  schema "prices" do
    field :properties, :map
    field :price, :integer

    belongs_to :list, List
    belongs_to :item, Item
  end

  def changeset(%Price{} = price, attrs) do
    price
    |> cast(attrs, [:properties, :price, :list_id, :item_id])
  end
end
