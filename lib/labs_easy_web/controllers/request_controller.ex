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

  def pre_signed_put(conn, %{"file_name" => fileName}) do
    opts = [virtual_host: true, bucket_as_host: true]
    fileName = "#{UUID.uuid4() |> String.split("-") |> List.first()}-#{fileName}"

    {:ok, url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_url(
        :put,
        Application.get_env(:ex_aws, :s3)[:host],
        fileName,
        opts
      )

    send_resp(
      conn,
      :ok,
      :json.encode(%{
        url: url,
        get_url:
          "https://pre-signed-demo-labs.s3.eu-north-1.amazonaws.com/#{URI.encode(fileName)}"
      })
    )
  end
end
