defmodule Cashier do
  import Ecto.Query, warn: false
  
  alias Elxloader.Repo
  alias Cashier.{List}

  def get_list(id) do
    List
    |> Repo.get(id)
  end
end
