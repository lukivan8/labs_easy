defmodule LabsEasyWeb.DefaultController do
  use LabsEasyWeb, :controller

  def index(conn, _params) do
    json(conn, %{message: "Hello, World!"})
  end
end
