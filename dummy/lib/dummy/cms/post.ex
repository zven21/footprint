defmodule Dummy.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string
    field :last_comment_id, :integer
    field :last_commented_at, :naive_datetime
    field :user_id, :integer

    timestamps()
  end

  def changeset(post, attrs) do
    optional_fields = ~w(
      last_commented_at
      last_comment_id
      user_id
    )a

    required_fields = ~w(
      title
      body
    )a

    post
    |> cast(attrs, optional_fields ++ required_fields)
    |> validate_required(required_fields)
  end
end
