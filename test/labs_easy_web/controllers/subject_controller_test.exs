defmodule LabsEasyWeb.SubjectControllerTest do
  use LabsEasyWeb.ConnCase

  import LabsEasy.ApplicationsFixtures

  alias LabsEasy.Applications.Subject

  @create_attrs %{
    name: "some name",
    course: 42
  }
  @update_attrs %{
    name: "some updated name",
    course: 43
  }
  @invalid_attrs %{name: nil, course: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all subjects", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/subjects")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create subject" do
    test "renders subject when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/subjects", subject: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/v1/subjects/#{id}")

      assert %{
               "id" => ^id,
               "course" => 42,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/subjects", subject: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update subject" do
    setup [:create_subject]

    test "renders subject when data is valid", %{conn: conn, subject: %Subject{id: id} = subject} do
      conn = put(conn, ~p"/api/v1/subjects/#{subject}", subject: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/subjects/#{id}")

      assert %{
               "id" => ^id,
               "course" => 43,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, subject: subject} do
      conn = put(conn, ~p"/api/v1/subjects/#{subject}", subject: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete subject" do
    setup [:create_subject]

    test "deletes chosen subject", %{conn: conn, subject: subject} do
      conn = delete(conn, ~p"/api/v1/subjects/#{subject}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/subjects/#{subject}")
      end
    end
  end

  defp create_subject(_) do
    subject = subject_fixture()
    %{subject: subject}
  end
end
