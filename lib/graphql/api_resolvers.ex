defmodule GraphQL.ApiResolvers do
  alias Cashier

  def find_list(_args, %{id: id}, _resolution) do
    case Cashier.get_list(id) do
      nil ->
        {:error, "List not found"}
      
      list ->
        {:ok, list}
    end
  end  
end
