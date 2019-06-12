defmodule Footprint.Comment do
  @moduledoc """
  Documentation for Version.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Footprint.{User, Post, Comment}

  @type t :: %Comment{}

  schema "comments" do
    field(:content, :string)

    belongs_to(:user, User)
    belongs_to(:post, Post)
  end

  def changeset(comment, attrs \\ %{}) do
    required_fields = ~w(
      content
      user_id
      post_id
    )a

    comment
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
