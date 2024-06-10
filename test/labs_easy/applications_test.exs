defmodule LabsEasy.ApplicationsTest do
  use LabsEasy.DataCase

  alias LabsEasy.Applications

  describe "requests" do
    alias LabsEasy.Applications.Request

    import LabsEasy.ApplicationsFixtures

    @invalid_attrs %{name: nil, type: nil, date: nil, contact: nil, subject: nil, attachment: nil}

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      assert Applications.list_requests() == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Applications.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      valid_attrs = %{
        name: "some name",
        type: 42,
        date: ~D[2024-06-03],
        contact: "some email",
        subject: "some subject",
        attachment: "some attachment"
      }

      assert {:ok, %Request{} = request} = Applications.create_request(valid_attrs)
      assert request.name == "some name"
      assert request.type == 42
      assert request.due_date == ~D[2024-06-03]
      assert request.email == "some email"
      assert request.subject == "some subject"
      assert request.attachment == "some attachment"
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()

      update_attrs = %{
        name: "some updated name",
        type: 43,
        date: ~D[2024-06-04],
        contact: "some updated email",
        subject: "some updated subject",
        attachment: "some updated attachment"
      }

      assert {:ok, %Request{} = request} = Applications.update_request(request, update_attrs)
      assert request.name == "some updated name"
      assert request.type == 43
      assert request.due_date == ~D[2024-06-04]
      assert request.email == "some updated email"
      assert request.subject == "some updated subject"
      assert request.attachment == "some updated attachment"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_request(request, @invalid_attrs)
      assert request == Applications.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Applications.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Applications.change_request(request)
    end
  end

  describe "subjects" do
    alias LabsEasy.Applications.Subject

    import LabsEasy.ApplicationsFixtures

    @invalid_attrs %{name: nil, course: nil}

    test "list_subjects/0 returns all subjects" do
      subject = subject_fixture()
      assert Applications.list_subjects() == [subject]
    end

    test "get_subject!/1 returns the subject with given id" do
      subject = subject_fixture()
      assert Applications.get_subject!(subject.id) == subject
    end

    test "create_subject/1 with valid data creates a subject" do
      valid_attrs = %{name: "some name", course: 42}

      assert {:ok, %Subject{} = subject} = Applications.create_subject(valid_attrs)
      assert subject.name == "some name"
      assert subject.course == 42
    end

    test "create_subject/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_subject(@invalid_attrs)
    end

    test "update_subject/2 with valid data updates the subject" do
      subject = subject_fixture()
      update_attrs = %{name: "some updated name", course: 43}

      assert {:ok, %Subject{} = subject} = Applications.update_subject(subject, update_attrs)
      assert subject.name == "some updated name"
      assert subject.course == 43
    end

    test "update_subject/2 with invalid data returns error changeset" do
      subject = subject_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_subject(subject, @invalid_attrs)
      assert subject == Applications.get_subject!(subject.id)
    end

    test "delete_subject/1 deletes the subject" do
      subject = subject_fixture()
      assert {:ok, %Subject{}} = Applications.delete_subject(subject)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_subject!(subject.id) end
    end

    test "change_subject/1 returns a subject changeset" do
      subject = subject_fixture()
      assert %Ecto.Changeset{} = Applications.change_subject(subject)
    end
  end
end
