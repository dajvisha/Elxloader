# Elxloader

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


# Explaining the problem
For starters, how does a simple implementation of the `dataLoader` using `Graphql`, really works

Assuming we have the following schemas:

```elixir
schema "lists" do
  has_many :prices, Price
end
schema "prices" do
  field :price, :integer
  belongs_to :list, List
  belongs_to :item, Item
end
schema "items" do
  has_many :prices, Price
end
````
From this we want to make a query in Graphql that works like:
```GraphQL
{
  list(id:1){
  	items{
      id
      price{
        price
      }
    }
  }
}
```
We defined our query like the following:
```elixir
field :list, :list do
  arg(:id, non_null(:id))
  resolve(&ApiResolvers.find_list/3)
end
```

There should be resolvers in the types for the methods of `lists` and `items` like
This goes down to the list type and sub-sequentially:
```elixir
object :list do
  # Attributes
  field :id, :id
  # Relationships
  field :items, list_of(:item) do
    resolve(&ApiResolvers.find_list_items/3)
  end
end
```
The connection of item to list is connected via the price. So normally, you would make a query to get
the prices associated with the `list_id`. Thats `1 Query` which is just perfect.
The problem lies in what comes after that, we would make a query for each `item_id` in each price. This are `N Queries`.
The `N+1 Queries` problem.

But there is another level in our initial query that is still not done:
```GraphQL
  items{
      id
      price{
        price
      }
  }
```
Of course, the resolver for this would go into the type of `Item` :

```elixir
object :item do
  field :id, :id
  # Relationships
  field :price, :price do
    resolve(&ApiResolvers.find_item_price/3)
  end
object :price do
  field :price, :integer
end
```
The same issue is present once we have the items and we want to put all their associated prices to their respective `Item`, once again we gain `M Queries` for each `Item`.

Going by our prior logic this would make `N*M+1 Queries`.
But this can be avoided and all of this could be reduced to a finite number of queries.

# Solving the problem

## Configuration

Implementing the dataLoader in our schemas, would change how the normal way of asking the `Repo` for information from the dataBase, in the example the `Cashier` would be the class that, in other instances would have the specific functions for the `Repo` and the `Item`, `List` and `Price` tables.

But now, this class only has a couple of instructions as a way of "setup"

`defmodule Elxloader.Cashier`
```elixir
def data() do
  Dataloader.Ecto.new(Repo, query: &query/2)
end

def query(queryable, _) do
  queryable
end
```
It is more of a generic class than anything else, this will go to work with the  `middleware` implemented with the dataloader and resolutions.

Next step is setting up our schemas, besides, importing the types we need to configure our dataLoader:

```elixir
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
```
In the plugins we are stating that we want `Absinthe` to handle the of `Middleware` of the dataLoader. So everything goes automatically later.

In the `context/1` function, we are quite explicitly stating that the loader be saved in the context.

`:loader` is a generic name, but depending on the application, you should have different types of loaders,
for example: `:list_item_loader` would be a more appropriate name, along with the `dataloader/2` function name.

This is all the configuration that we need in order to start working with the loader instead of the Repo.

## DataLoader Resolvers

The resolvers would be really similar but solving the second level of our query
```GraphQL
  items{
      id
      price{
        price
      }
  }
```
would be the best to understand how it works:
```elixir
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
```
Normally, the function name would be something like:
```elixir
def find_list_items(list, _params, _resolution) do
```
But in our configuration above we stated that the context will now have the loader,
the loader specifically for the `Cashier`.
So now, the resolution has something that we want, the loader, of course.
The `on_load/2` needs to be imported specifically. This function is useful to us, even though it is said that it is rarely used, it grants us more control for our dataloader. Enabling a way to load more things in a single resolver.

As we can see we are loading the `:prices`, for the specific list, then after getting those, we load even more with the `:items`, for each element in `prices` it goes through the associations, and returns the one you specify.

And finally, we return the items from the DataBase. Remembering that this query was indeed `N Queries` we have reduced it to only `3 Queries`.

When the next query is called, using the dataloader in the manner as this one, the total number ends up being `4 Queries`
A massive improvement over the `N*M+1 Queries` that started our problem.


## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
