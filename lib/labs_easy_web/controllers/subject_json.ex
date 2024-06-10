defmodule LabsEasyWeb.SubjectJSON do
  alias LabsEasy.Applications.Subject

  @doc """
  Renders a list of subjects.
  """
  def index(%{subjects: subjects}) do
    %{data: for(subject <- subjects, do: data(subject))}
  end

  @doc """
  Renders a single subject.
  """
  def show(%{subject: subject}) do
    %{data: data(subject)}
  end

  defp data(%Subject{} = subject) do
    %{
      id: subject.id,
      name: subject.name,
      course: subject.course
    }
  end
end
