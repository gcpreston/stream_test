defmodule StreamTest.Repo.Migrations.CreateModels do
  use Ecto.Migration

  def change do
    create table(:models) do
      add :content, :text

      timestamps()
    end
  end
end
