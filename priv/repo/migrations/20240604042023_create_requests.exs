defmodule LabsEasy.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:requests) do
      add :name, :string
      add :contact, :string
      add :type, :integer
      add :attachment, :string
      add :due_date, :date
      add :description, :text
      add :price, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
