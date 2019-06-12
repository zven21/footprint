defmodule Footprint.User do
  @moduledoc """
  Documentation for Version.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Footprint.{Post, User, Comment}

  @type t :: %User{}

  schema "users" do
    field(:nickname, :string)

    has_many(:posts, Post)
    has_many(:comments, Comment)
  end

  def changeset(user, attrs \\ %{}) do
    required_fields = ~w(
      nickname
    )a

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
