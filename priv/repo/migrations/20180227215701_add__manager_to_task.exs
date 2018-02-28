defmodule Tasktracker.Repo.Migrations.Add_ManagerToTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :manager_id, references(:users, on_delete: :nothing)

    end
  end
end
