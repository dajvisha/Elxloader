defmodule Elxloader.Repo.Migrations.AddPriceTable do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :list_id, references(:lists, on_delete: :nothing)
      add :properties, :map
      add :price, :integer
    end
  end
end
