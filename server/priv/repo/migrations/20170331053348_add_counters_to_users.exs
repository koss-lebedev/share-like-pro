defmodule Commently.Repo.Migrations.AddCountersToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :share_count, :integer, default: 0
      add :error_count, :integer, default: 0
    end
  end
end
