defmodule GraphQL.ApiResolvers do
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def find_list(_args, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Cashier, Cashier.Item, id)
    |> on_load(fn loader -> 
      list = Dataloader.get(loader, Cashier, Cashier.Item, id)
      {:ok, list}
    end)
  end
end
