defmodule Commently.Repo.Migrations.RemoveComments do
  use Ecto.Migration

  def change do
    drop table(:comments)
  end
end
