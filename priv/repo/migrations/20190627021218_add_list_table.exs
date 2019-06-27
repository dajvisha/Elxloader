defmodule Elxloader.Repo.Migrations.AddListTable do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name, :string
      add :properties, :map
    end
  end
end
