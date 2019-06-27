defmodule Elxloader.Repo.Migrations.AddItemTable do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :product_code, :string
      add :name, :string
    end
  end
end
