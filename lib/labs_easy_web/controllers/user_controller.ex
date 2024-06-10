defmodule LabsEasyWeb.UserController do
  use LabsEasyWeb, :controller
  alias LabsEasy.Accounts.User

  def create(conn, %{"email" => email, "password" => password}) do
    case User.create_user(email, password) |> IO.inspect() do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(:show, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)

      {:error, _changeset} ->
        conn
        |> resp(422, "Nah")
    end
  end
end
