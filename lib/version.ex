defmodule Footprint.Version do
  @moduledoc """
  Documentation for Version.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Footprint.Version

  @type t :: %Version{}

  schema "versions" do
    field(:no, :integer)
    field(:item_base, :string)
    field(:item_id, :integer)
    field(:item_type, :string)
    field(:event, :string)
    field(:item_prev, :map)
    field(:item_current, :map)
    field(:item_changes, :map)
    field(:origin, :string)
    field(:meta, :map)

    timestamps(updated_at: false)
  end

  def changeset(attrs \\ %{}) do
    required_fields = ~w(
      no
      item_base
      item_id
      item_type
      item_changes
      item_prev
      item_current
    )a

    optional_fields = ~w(
      origin
      meta
    )a

    %Version{}
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
