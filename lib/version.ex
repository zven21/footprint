defmodule Footprint.Version do
  @moduledoc """
  Documentation for Version.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Footprint.Version

  @type t :: %Version{}

  schema "versions" do
    field(:item_type, :string)
    field(:item_id, :integer)
    field(:item_prev, :map)
    field(:item_current, :map)
    field(:origin, :string)
    field(:meta, :map)

    timestamps(updated_at: false)
  end

  def changeset(attrs \\ %{}) do
    required_fields = ~w(

    )a

    optional_fields = ~w(
      origin
      meta
      item_id
      item_type
      item_prev
      item_current
    )a

    %Version{}
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
