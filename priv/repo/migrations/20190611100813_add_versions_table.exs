defmodule Footprint.Repo.Migrations.AddVersionsTable do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :item_type, :string, null: false
      add :item_id, :integer, null: false
      add :item_prev, :map, null: false
      add :item_current, :map, null: false
      add :origin, :string
      add :meta, :map

      add :inserted_at, :utc_datetime, null: false
    end

    create index(:versions, [:item_type, :item_id])
  end
end
