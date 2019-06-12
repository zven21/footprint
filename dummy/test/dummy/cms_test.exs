defmodule Dummy.CMSTest do
  use Dummy.DataCase

  alias Dummy.CMS

  describe "posts" do
    alias Dummy.CMS.Post

    @valid_attrs %{
      body: "some body",
      last_comment_id: 42,
      last_commented_at: ~N[2010-04-17 14:00:00],
      title: "some title",
      user_id: 42
    }
    @update_attrs %{
      body: "some updated body",
      last_comment_id: 43,
      last_commented_at: ~N[2011-05-18 15:01:01],
      title: "some updated title",
      user_id: 43
    }
    @invalid_attrs %{
      body: nil,
      last_comment_id: nil,
      last_commented_at: nil,
      title: nil,
      user_id: nil
    }

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert CMS.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert CMS.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = CMS.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.last_comment_id == 42
      assert post.last_commented_at == ~N[2010-04-17 14:00:00]
      assert post.title == "some title"
      assert post.user_id == 42
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = CMS.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.last_comment_id == 43
      assert post.last_commented_at == ~N[2011-05-18 15:01:01]
      assert post.title == "some updated title"
      assert post.user_id == 43
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_post(post, @invalid_attrs)
      assert post == CMS.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = CMS.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = CMS.change_post(post)
    end
  end
end
