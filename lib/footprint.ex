defmodule Footprint do
  @moduledoc """
  Documentation for Footprint.

  ## Examples

      iex> Footprint.insert()
      iex> Footprint.update()
      iex> Footprint.transaction()

  """

  alias Ecto.Multi
  alias Footprint.Client, as: FC

  @doc """
  build insert func.
  """
  @spec insert(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(changeset) do
    repo = FC.repo()

    changeset |> repo.insert()
  end

  @doc """
  build update func.
  """
  @spec update(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update(changeset) do
    repo = FC.repo()

    Multi.new()
    |> Multi.update(:model, changeset)
    |> Multi.run(:version, fn repo, %{model: _} ->
      %{
        item_type: changeset.data.__struct__ |> Module.split() |> List.last(),
        item_id: changeset.data.id,
        item_prev: build_item_prev(changeset),
        item_current: build_item_current(changeset)
      }
      |> Footprint.Version.changeset()
      |> repo.insert()
    end)
    |> repo.transaction()
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
