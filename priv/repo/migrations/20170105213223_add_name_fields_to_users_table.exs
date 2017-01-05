defmodule MusicQuiz.Repo.Migrations.AddNameFieldsToUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string, size: 40
      add :last_name, :string, size: 40
    end
  end
end
