defmodule Mix.Tasks.Footprint.Init do
  @moduledoc false

  use Mix.Task

  import Mix.Generator

  def run(_args) do
    path = Path.relative_to("priv/repo/migrations", Mix.Project.app_path())
    file = Path.join(path, "#{timestamp()}_add_versions_table.exs")
    create_directory(path)

    create_file(file, """
    defmodule Repo.Migrations.AddVersions do
      use Ecto.Migration
      def change do
        create table(:versions) do
          add :event,        :string
          add :no,           :integer
          add :item_base,    :string
          add :item_type,    :string, null: false
          add :item_id,      :integer
          add :item_current, :map, null: false
          add :item_prev,    :map, null: false
          add :item_changes, :map, null: false
          add :meta,         :map
          add :origin,       :string
          add :inserted_at,  :utc_datetime, null: false
        end

        create index(:versions, [:item_id, :item_type])
      end
    end
    """)
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end
