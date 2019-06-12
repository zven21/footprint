defmodule Footprint.Post do
  @moduledoc """
  Documentation for Version.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Footprint.{Post, User, Comment}

  @type t :: %Post{}

  schema "posts" do
    field(:title, :string)
    field(:body, :integer)
    field(:last_commented_at, :utc_datetime, null: true)
    # field(:last_comment_id)

    belongs_to(:user, User)

    has_many(:comments, Comment)
  end

  def changeset(post, attrs \\ %{}) do
    required_fields = ~w(
      title
      body
    )a

    optional_fields = ~w(
      last_replied_at
      user_id
    )a

    post
    |> cast(attrs, required_fields ++ optional_fields)
    |> validate_required(required_fields)
  end
end
