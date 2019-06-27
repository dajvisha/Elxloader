defmodule GraphQL.ApiSchema do
  use Absinthe.Schema

  alias Cashier
  alias GraphQL.ApiResolvers

  import_types(GraphQL.ApiTypes)

  # Dataloader Configuration

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def dataloader() do
    Dataloader.new()
    |> Dataloader.add_source(Cashier, Cashier.data())
  end

  def context(ctx) do
    Map.put(ctx, :loader, dataloader())
  end

  # Schema Configuration

  query do
    field :list, :list do
      arg(:id, non_null(:id))
      resolve(&ApiResolvers.find_list/3)
    end
  end
end
