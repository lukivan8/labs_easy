defmodule LabsEasyWeb.RequestControllerTest do
  use LabsEasyWeb.ConnCase

  import LabsEasy.ApplicationsFixtures

  alias LabsEasy.Applications.Request

  @create_attrs %{
    name: "some name",
    type: 42,
    date: ~D[2024-06-03],
    contact: "some email",
    subject: "some subject",
    attachment: "some attachment"
  }
  @update_attrs %{
    name: "some updated name",
    type: 43,
    date: ~D[2024-06-04],
    contact: "some updated email",
    subject: "some updated subject",
    attachment: "some updated attachment"
  }
  @invalid_attrs %{name: nil, type: nil, date: nil, contact: nil, subject: nil, attachment: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all requests", %{conn: conn} do
      conn = get(conn, ~p"/api/requests")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create request" do
    test "renders request when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/requests", request: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/requests/#{id}")

      assert %{
               "id" => ^id,
               "attachment" => "some attachment",
               "date" => "2024-06-03",
               "email" => "some email",
               "name" => "some name",
               "subject" => "some subject",
               "type" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/requests", request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request" do
    setup [:create_request]

    test "renders request when data is valid", %{conn: conn, request: %Request{id: id} = request} do
      conn = put(conn, ~p"/api/requests/#{request}", request: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/requests/#{id}")

      assert %{
               "id" => ^id,
               "attachment" => "some updated attachment",
               "date" => "2024-06-04",
               "email" => "some updated email",
               "name" => "some updated name",
               "subject" => "some updated subject",
               "type" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, request: request} do
      conn = put(conn, ~p"/api/requests/#{request}", request: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete request" do
    setup [:create_request]

    test "deletes chosen request", %{conn: conn, request: request} do
      conn = delete(conn, ~p"/api/requests/#{request}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/requests/#{request}")
      end
    end
  end

  defp create_request(_) do
    request = request_fixture()
    %{request: request}
  end
end
