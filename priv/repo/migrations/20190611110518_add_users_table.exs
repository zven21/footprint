defmodule Footprint.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:nickname, :string, null: false)
    end
  end
end
