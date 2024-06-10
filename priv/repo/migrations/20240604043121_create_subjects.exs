defmodule LabsEasy.Repo.Migrations.CreateSubjects do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:subjects) do
      add :name, :string
      add :course, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
