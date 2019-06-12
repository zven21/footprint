defmodule Footprint.Factory do
  use ExMachina.Ecto, repo: Footprint.Repo

  alias Footprint.{Post, Comment, User}

  @doc """
  Creates a post object.
  """
  @spec post_factory :: Post.t()
  def post_factory do
    %Post{
      title: sequence(:title, &"title_#{&1}")
    }
  end

  @doc """
  Creates a comment object.
  """
  @spec comment_factory :: Comment.t()
  def comment_factory do
    %Comment{
      content: sequence(:content, &"content_#{&1}")
    }
  end

  @doc """
  Creates a user object.
  """
  @spec user_factory :: User.t()
  def user_factory do
    %User{
      nickname: sequence(:nickname, &"nickname_#{&1}")
    }
  end
end
