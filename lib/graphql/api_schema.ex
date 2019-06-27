defmodule GraphQL.ApiSchema do
  use Absinthe.Schema

  import_types(GraphQL.ApiTypes)

  query do
    # Some queries here
  end
end
