defmodule Commently.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :url, :string

      timestamps()
    end

  end
end
