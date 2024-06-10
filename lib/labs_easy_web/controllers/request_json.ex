defmodule LabsEasyWeb.RequestJSON do
  alias LabsEasy.Applications.Request

  @doc """
  Renders a list of requests.
  """
  def index(%{requests: requests}) do
    %{data: for(request <- requests, do: data(request))}
  end

  @doc """
  Renders a single request.
  """
  def show(%{request: request}) do
    %{data: data(request)}
  end

  defp data(%Request{} = request) do
    %{
      id: request.id,
      name: request.name,
      contact: request.contact,
      subject_id: request.subject_id,
      type: request.type,
      attachment: request.attachment,
      date: request.due_date,
      description: request.description,
      price: request.price
    }
  end
end
