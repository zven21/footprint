defmodule Footprint do
  @moduledoc false

  alias Ecto.Multi
  alias Footprint.Client, as: FC

  # def insert!(), do: nil
  # def update!(), do: nil
  # def detete!(), do: nil
  # def insert_or_update(), do: nil
  # def get_version(), do: nil,
  # def get_versions(), do: nil,
  # def diff(), do: nil,
  # def apply(), do: nil,
  # def inspect(), do: nil

  @doc """
  build insert func.
  """
  @spec insert(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(changeset) do
    repo = FC.repo()

    Multi.new()
    |> Multi.insert(:model, changeset)
    |> Multi.run(:version, fn repo, %{model: model} ->
      %{
        item_base: changeset.data.__struct__ |> to_string(),
        item_type: changeset.data.__struct__ |> Module.split() |> List.last(),
        item_id: model.id,
        item_prev: build_item_prev(changeset),
        item_changes: bulid_item_changes(changeset),
        item_current: build_item_current(changeset)
      }
      |> Footprint.Version.changeset()
      |> repo.insert()
    end)
    |> repo.transaction()
  end

  @doc """
  build update func.
  """
  @spec update(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update(changeset) do
    repo = FC.repo()

    Multi.new()
    |> Multi.update(:model, changeset)
    |> Multi.run(:version, fn repo, %{model: model} ->
      %{
        item_base: changeset.data.__struct__ |> to_string(),
        item_type: changeset.data.__struct__ |> Module.split() |> List.last(),
        item_id: model.id,
        item_changes: bulid_item_changes(changeset),
        item_prev: build_item_prev(changeset),
        item_current: build_item_current(changeset)
      }
      |> Footprint.Version.changeset()
      |> repo.insert()
    end)
    |> repo.transaction()
  end

  @doc """
  Delete Func.
  """
  @spect delete(Ecto.Schema.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(struct) do
    repo = FC.repo()

    Multi.new()
    |> Multi.delete(:model, struct)
    |> Multi.run(:version, fn repo, %{} ->
      %{
        item_base: struct.__struct__ |> to_string(),
        item_type: struct.__struct__ |> Module.split() |> List.last(),
        item_id: struct.id,
        item_changes: struct |> Map.from_struct() |> Map.delete(:__meta__),
        item_prev: struct |> Map.from_struct() |> Map.delete(:__meta__),
        item_current: %{}
      }
      |> Footprint.Version.changeset()
      |> repo.insert()
    end)
    |> repo.transaction()
  end

  @doc """
  Prepase add footprint_fields_labels to origin Module.
  Post.footprint_field_labels = %{title: "Title", body: "Body"}

  ## Examples

    > version1 |> Footprint.inspect
    %{"Body" => [nil, "body2"], "Title" => [nil, "title1"]}

  """
  def inspect(version) do
    module_base = version |> Map.get(:item_base) |> String.to_atom()
    item_changes = version |> Map.get(:item_changes)

    module_base
    |> apply(:__info__, [:functions])
    |> Keyword.has_key?(:footprint_field_labels)
    |> case do
      true ->
        footprint_labels =
          module_base
          |> apply(:footprint_field_labels, [])

        item_changes
        |> Enum.into(%{}, fn {k, v} -> {Map.get(footprint_labels, String.to_atom(k), k), v} end)

      _ ->
        item_changes
    end
  end

  defp bulid_item_changes(changeset) do
    changeset
    |> build_item_current()
    |> Enum.into(%{}, fn {k, v} -> {k, [Map.get(changeset.data, k), v]} end)
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
