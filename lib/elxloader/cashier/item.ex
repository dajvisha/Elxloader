defmodule Cashier.Item do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__, as: Item
  alias Cashier.Price

  schema "items" do
    field :product_code, :string
    field :name, :string

    has_many :prices, Price
  end

  def changeset(%Item{} = item, attrs) do
    item
    |> cast(attrs, [:product_code, :name])
  end
end
