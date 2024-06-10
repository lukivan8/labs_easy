defmodule LabsEasyWeb.SubjectController do
  use LabsEasyWeb, :controller

  alias LabsEasy.Applications
  alias LabsEasy.Applications.Subject

  action_fallback LabsEasyWeb.FallbackController

  def index(conn, _params) do
    subjects = Applications.list_subjects()
    render(conn, :index, subjects: subjects)
  end

  def create(conn, %{"subject" => subject_params}) do
    with {:ok, %Subject{} = subject} <- Applications.create_subject(subject_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/subjects/#{subject}")
      |> render(:show, subject: subject)
    end
  end

  def show(conn, %{"id" => id}) do
    subject = Applications.get_subject!(id)
    render(conn, :show, subject: subject)
  end

  def update(conn, %{"id" => id, "subject" => subject_params}) do
    subject = Applications.get_subject!(id)

    with {:ok, %Subject{} = subject} <- Applications.update_subject(subject, subject_params) do
      render(conn, :show, subject: subject)
    end
  end

  def delete(conn, %{"id" => id}) do
    subject = Applications.get_subject!(id)

    with {:ok, %Subject{}} <- Applications.delete_subject(subject) do
      send_resp(conn, :no_content, "")
    end
  end
end
