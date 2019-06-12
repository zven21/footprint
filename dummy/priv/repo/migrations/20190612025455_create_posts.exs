defmodule Dummy.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string
      add :last_commented_at, :naive_datetime
      add :last_comment_id, :integer
      add :user_id, :integer

      timestamps()
    end
  end
end
