defmodule GraphQL.ApiSchema do
  use Absinthe.Schema

  alias GraphQL.ApiResolvers

  import_types(GraphQL.ApiTypes)

  query do
    field :list, :list do
      arg(:id, non_null(:id))
      resolve(&ApiResolvers.find_list/3)
    end
  end
end
