defmodule Footprint do
  @moduledoc """
  Documentation for Footprint.
  """

  alias Ecto.Multi
  alias Footprint.Version
  alias Footprint.Client, as: FC

  @repo FC.repo()

  @doc """
  Insert version.
  """
  @spec insert(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(changeset) do
    Multi.new()
    |> Multi.insert(:model, changeset)
    |> may_insert_version()
    |> @repo.transaction()
  end

  def may_insert_version(multi) do
    IO.inspect(multi)

    insert_version_fn = fn %{model: changeset} ->
      # when object first create, not need create version.
      if changeset.data.id do
        attrs = %{
          item_type: changeset.data.__struct__ |> Module.split() |> List.last(),
          item_id: changeset.data.id,
          item_prev: build_item_prev(changeset),
          item_current: build_item_current(changeset)
        }

        case Footprint.insert_version(attrs) do
          {:ok, topic} -> {:ok, topic}
          {:error, reason} -> {:error, reason}
        end
      end
    end

    Multi.insert(multi, :may_insert_version, insert_version_fn)
  end

  def insert_version(attrs) do
    attrs
    |> Version.changeset()
    |> @repo.insert()
  end

  defp build_item_current(changeset) do
    changeset
    |> serialize()
  end

  defp build_item_prev(changeset) do
    changeset
    |> build_item_current()
    |> Enum.into(%{}, fn {k, _v} -> {k, Map.get(changeset.data, k)} end)
  end

  defp serialize(changeset) do
    relationships = changeset.data.__struct__.__schema__(:associations)
    Map.drop(changeset.changes, relationships)
  end
end
