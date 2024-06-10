defmodule LabsEasyWeb.RequestController do
  use LabsEasyWeb, :controller

  alias LabsEasy.Applications
  alias LabsEasy.Applications.Request

  action_fallback LabsEasyWeb.FallbackController

  def index(conn, _params) do
    requests = Applications.list_requests()
    render(conn, :index, requests: requests)
  end

  def create(conn, %{"request" => request_params}) do
    with {:ok, %Request{} = request} <- Applications.create_request(request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/requests/#{request}")
      |> render(:show, request: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Applications.get_request!(id)
    render(conn, :show, request: request)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Applications.get_request!(id)

    with {:ok, %Request{} = request} <- Applications.update_request(request, request_params) do
      render(conn, :show, request: request)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Applications.get_request!(id)

    with {:ok, %Request{}} <- Applications.delete_request(request) do
      send_resp(conn, :no_content, "")
    end
  end
end
