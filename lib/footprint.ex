defmodule Footprint do
  @moduledoc """

  ## TODO

    - [x] insert! and insert func.
    - [x] update! and update func.
    - [x] delete! and delete func.
    - [ ] insert_or_update! and insert_or_update func.
    - [x] get_version and get_versions func.
    - [ ] version diff and apply func.
    - [x] footprint.inspect func.

  """

  alias Ecto.Multi
  alias Footprint.Version
  alias Footprint.Client, as: FC

  defdelegate get_version(record), to: Footprint.VersionQueries
  defdelegate get_version(model_or_record, id_or_options), to: Footprint.VersionQueries
  defdelegate get_version(model, id, options), to: Footprint.VersionQueries

  defdelegate get_versions(record), to: Footprint.VersionQueries
  defdelegate get_versions(model_or_record, id_or_options), to: Footprint.VersionQueries
  defdelegate get_versions(model, id, options), to: Footprint.VersionQueries

  defdelegate get_current_model(version), to: Footprint.VersionQueries

  @doc """
  Same as insert/2

  ## Example

      iex> Post.changeset(%Post{}, %{title: "t1", body: "b1"}) |> Footprint.insert()
      {:ok, %{model: %Dummy.CMS.Post{}, version: %Footprint.Version{}}

      iex> Post.changeset(%Post{}, %{title: "t1"}) |> Footprint.insert
      {:error, :model, #Ecto.Changeset<>, %{}}

  """
  @spec insert(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def insert(changeset, options \\ [meta: nil]) do
    repo = FC.repo()

    Multi.new()
    |> Multi.insert(:model, changeset)
    |> Multi.run(:version, fn repo, %{model: model} ->
      make_version_struct(%{event: "insert"}, changeset, model, options)
      |> repo.insert()
    end)
    |> repo.transaction()
  end

  @doc """
  Same as insert/2 but returns only the model struct or raises if the changeset is invalid.

  ## Examples

      iex> Post.changeset(%Post{}, %{title: "t1", body: "b1"}) |> Footprint.insert!()
      %Dummy.CMS.Post{}

      iex> Post.changeset(%Post{}, %{title: "t1"}) |> Footprint.insert!()
      ** (Ecto.InvalidChangesetError)

  """
  def insert!(changeset, options \\ [meta: nil]) do
    repo = FC.repo()

    repo.transaction(fn ->
      model = repo.insert!(changeset)
      make_version_struct(%{event: "insert"}, changeset, model, options) |> repo.insert!()
      model
    end)
    |> elem(1)
  end

  @doc """
  Same as update/2

  ## Examples

      iex> p1 = Repo.get(Post, 1)
      iex> Post.changeset(p1, %{title: "t2"}) |> Footprint.update()
      {:ok, %{model: %Dummy.CMS.Post{}, version: %Footprint.Version{}}

      iex> Post.changeset(p1, %{title: "tttttt7"}) |> Footprint.update()
      {:error, :model, #Ecto.Changeset<>, %{}}

  """
  @spec update(Ecto.Changeset.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def update(changeset, options \\ [meta: nil]) do
    repo = FC.repo()

    Multi.new()
    |> Multi.update(:model, changeset)
    |> Multi.run(:version, fn repo, %{model: model} ->
      make_version_struct(%{event: "update"}, changeset, model, options)
      |> repo.insert()
    end)
    |> repo.transaction()
  end

  @doc """
  Same as update!/2

  ## Examples

      iex> p1 = Repo.get(Post, 1)
      iex> Post.changeset(p1, %{title: "t2"}) |> Footprint.update()
      %Dummy.CMS.Post{}

      iex> Post.changeset(p1, %{title: "tttttt7"}) |> Footprint.update!()
      ** (Ecto.InvalidChangesetError)

  """
  def update!(changeset, options \\ [meta: nil]) do
    repo = FC.repo()

    repo.transaction(fn ->
      model = repo.update!(changeset)
      make_version_struct(%{event: "update"}, changeset, model, options) |> repo.insert!()
      model
    end)
    |> elem(1)
  end

  @doc """
  Same as delete/2

  ## Examples

      iex> p1 = Repo.get(Post, 1)
      iex> p1 |> Footprint.delete()
      {:ok, %{model: %Dummy.CMS.Post{}, version: %Footprint.Version{}}

  """
  @spec delete(Ecto.Schema.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(struct, options \\ [meta: nil]) do
    repo = FC.repo()

    Multi.new()
    |> Multi.delete(:model, struct)
    |> Multi.run(:version, fn repo, %{} ->
      make_version_struct(%{event: "delete"}, struct, options)
      |> repo.insert()
    end)
    |> repo.transaction()
  end

  @doc """
  Sames as delete!/2

  ## Examples

      iex> p1 = Repo.get(Post, 1)
      iex> p1 |> Footprint.delete!()
      %Dummy.CMS.Post{}

  """
  def delete!(struct, options \\ [meta: nil]) do
    repo = FC.repo()

    repo.transaction(fn ->
      model = repo.delete!(struct, options)
      make_version_struct(%{event: "delete"}, struct, options) |> repo.insert!()
      model
    end)
    |> elem(1)
  end

  @doc """
  Prepase add footprint_fields_labels to origin Module.

  ## Examples

    Post.footprint_field_labels = %{title: "Title", body: "Body"}
    iex> version1 |> Footprint.inspect
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

  defp make_version_struct(%{event: "insert"}, changeset, model, options) do
    %Version{
      no: 1,
      event: "insert",
      item_base: model.__struct__ |> to_string(),
      item_type: model.__struct__ |> Module.split() |> List.last(),
      item_id: model.id,
      item_prev: build_item_prev(changeset),
      item_changes: bulid_item_changes(changeset),
      item_current: build_item_current(changeset),
      meta: options[:meta]
    }
  end

  defp make_version_struct(%{event: "update"}, changeset, model, options) do
    %Version{
      no: build_item_version_no(model),
      event: "update",
      item_base: changeset.data.__struct__ |> to_string(),
      item_type: changeset.data.__struct__ |> Module.split() |> List.last(),
      item_id: changeset.data.id,
      item_prev: build_item_prev(changeset),
      item_changes: bulid_item_changes(changeset),
      item_current: build_item_current(changeset),
      meta: options[:meta]
    }
  end

  defp make_version_struct(%{event: "delete"}, model, options) do
    %Version{
      no: build_item_version_no(model),
      event: "delete",
      item_base: model.__struct__ |> to_string(),
      item_type: model.__struct__ |> Module.split() |> List.last(),
      item_id: model.id,
      item_prev: model |> Map.from_struct() |> Map.delete(:__meta__),
      item_changes: model |> Map.from_struct() |> Map.delete(:__meta__),
      item_current: %{},
      meta: options[:meta]
    }
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

  defp build_item_version_no(model) do
    model
    |> get_version()
    |> Map.get(:no)
    |> Kernel.+(1)
  end
end
