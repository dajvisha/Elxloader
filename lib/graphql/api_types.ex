defmodule GraphQL.ApiTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Niffler.Repo

  alias GraphQL.ApiResolvers

  object :list do
    # Attributes
    field :id, :id
    field :name, :string
    field :properties, :list_properties

    # Relationships
    field :items, list_of(:item) do
      resolve(&ApiResolvers.find_list_items/3)
    end
  end

  object :price do
    field :id, :id
    field :price, :integer
    field :properties, :price_properties
  end

  object :item do
    field :product_code, :string
    field :name, :string

    # Relationships
    field :price, :price do
      resolve(&ApiResolvers.find_item_price/3)
    end
  end

  object :list_properties do
    field :department, :string
  end

  object :price_properties do
    field :age, :string
  end
end
