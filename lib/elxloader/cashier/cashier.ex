defmodule Cashier do
  import Ecto.Query, warn: false
  
  alias Elxloader.Repo
  alias Cashier.{List}

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(queryable, _) do
    queryable
  end
end
