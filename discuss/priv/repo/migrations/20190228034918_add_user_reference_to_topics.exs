defmodule Discuss.Repo.Migrations.AddUserReferenceToTopics do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      # add a foreign key reference
      add :user_id, references(:users)
    end
  end
end
