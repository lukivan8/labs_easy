defmodule LabsEasyWeb.UserJSON do
  import LabsEasy.Helpers.Response

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def error(%{changeset: changeset}) do
    %{
      errors: changeset_error(changeset)
    }
  end

  def data(%LabsEasy.Accounts.User{} = user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
