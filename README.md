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
Of course, the resolver for this would fo into the type of `Item` :

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
The same issue is present once we have the items and we want to put all their associated prices to their respective `Item`
we, once again we gain `M Queries` for each `Item`.

Going by our prior logic this would make `N*M+1 Queries`.
But this can be avoided and all of this could be reduced to a finite number of queries.

# Solving the problem



## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
