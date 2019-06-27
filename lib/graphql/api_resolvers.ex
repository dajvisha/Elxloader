defmodule GraphQL.ApiResolvers do
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def find_list(_args, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Cashier, Cashier.List, id)
    |> on_load(fn loader ->
      list = Dataloader.get(loader, Cashier, Cashier.List, id)

      {:ok, list}
    end)
  end

  def find_list_items(list, _params, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Cashier, :prices, list)
    |> on_load(fn loader ->
      prices = Dataloader.get(loader, Cashier, :prices, list)

      loader
      |> Dataloader.load_many(Cashier, :item, prices)
      |> on_load(fn loader ->
        items = Dataloader.get_many(loader, Cashier, :item, prices)

        {:ok, items}
      end)
    end)
  end

  def find_item_price(item, _args, %{context: %{loader: loader}}) do
    %{sources: %{Cashier => %{results: results}}} = loader

    data =
      results
      |> Map.to_list()
      |> Enum.at(0)

    {_, {:ok, %{[1] => values}}} = data

    price =
      values
      |> Enum.filter(fn value ->
        Map.get(value, :item_id) == item.id
      end)
      |> Enum.at(0)

    {:ok, price}
  end
end
