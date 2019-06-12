defmodule Dummy.CMS.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :last_comment_id, :integer
    field :last_commented_at, :naive_datetime
    field :title, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    optional_attrs = ~w(
      last_commented_at
      last_comment_id
      user_id
    )a

    required_attrs = ~w(
      title
      body
    )a

    post
    |> cast(attrs, optional_attrs ++ required_attrs)
    |> validate_required(required_attrs)
  end
end
