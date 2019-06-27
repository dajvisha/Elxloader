defmodule Elxloader.Repo.Migrations.AddPriceItemTable do
  use Ecto.Migration

  def change do
    alter table(:prices) do
      add :item_id, references(:items, on_delete: :nothing)
    end
  end
end
