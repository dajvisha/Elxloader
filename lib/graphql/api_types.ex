defmodule GraphQL.ApiTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Niffler.Repo
  
  object :list do
    field :id, :id
    field :name, :string
    field :properties, :list_properties
  end

  object :price do
    field :id, :id
    field :price, :integer
    field :properties, :price_properties
  end

  object :item do
    field :product_code, :string
    field :name, :string
  end

  object :list_properties do
    field :department, :string
  end

  object :price_properties do
    field :age, :string
  end
end
