defmodule LabsEasy.Repo.Migrations.SubjectRef do
  use Ecto.Migration

  def change do
    alter table(:requests) do
      add :subject_id, references(:subjects, on_delete: :nothing)
    end
  end
end
