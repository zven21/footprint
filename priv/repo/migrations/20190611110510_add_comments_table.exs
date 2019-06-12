defmodule Footprint.Repo.Migrations.AddCommentsTable do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add(:content, :string, null: false)
      add(:post_id, :integer, null: false)
      add(:user_id, :integer, null: false)
    end
  end
end
