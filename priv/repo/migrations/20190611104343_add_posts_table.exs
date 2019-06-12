defmodule Footprint.Repo.Migrations.AddPostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string, null: false)
      add(:body, :string, null: false)
      add(:user_id, :integer)
      add(:last_commented_at, :utc_datetime)
    end
  end
end
