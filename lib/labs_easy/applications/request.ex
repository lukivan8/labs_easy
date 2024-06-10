defmodule LabsEasy.Applications.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :name, :string
    field :type, Ecto.Enum, values: [lab: 1, consultation: 2, diploma: 3, other: 4]
    field :due_date, :date
    field :contact, :string
    field :subject_id, :integer
    # URL to the attachment on S3
    field :attachment, :string

    field :description, :string
    field :price, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [
      :name,
      :type,
      :due_date,
      :contact,
      :subject_id,
      :attachment,
      :description,
      :price
    ])
    |> validate_required([:name, :subject_id, :type, :due_date, :price, :contact])
    |> foreign_key_constraint(:subject_id)
    |> validate_number(:price, greater_than: 0)
  end
end
