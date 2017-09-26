defmodule Commently.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :external_id, :string
      add :name, :string
      add :token, :string
      add :secret, :string
      add :avatar, :string

      timestamps()
    end

  end
end
