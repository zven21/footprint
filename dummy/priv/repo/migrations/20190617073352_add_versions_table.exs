defmodule Repo.Migrations.AddVersions do
  use Ecto.Migration
  def change do
    create table(:versions) do
      add :event,         :string
      add :no,            :integer
      add :item_base,     :string
      add :item_type,     :string, null: false
      add :item_id,       :integer
      add :item_current,  :map, null: false
      add :item_prev,     :map, null: false
      add :item_changes,  :map, null: false
      add :meta,          :map
      add :origin,        :string
      add :originator_id, :integer
      add :inserted_at,   :utc_datetime, null: false
    end

    create index(:versions, [:item_id, :item_type])
  end
end
