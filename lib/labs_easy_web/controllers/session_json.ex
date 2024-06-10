defmodule LabsEasyWeb.SessionJSON do
  alias LabsEasy.Repo
  alias LabsEasy.Accounts.AuthToken

  def show(%{auth_token: token}) do
    %{data: %{token: data(token)}}
  end

  def data(%AuthToken{} = token) do
    %{
      id: token.id,
      token: token.token,
      revoked: token.revoked,
      revoked_at: token.revoked_at,
      user: get_user(token)
    }
  end

  defp get_user(%AuthToken{} = token) do
    user = Repo.preload(token, :user).user

    %{
      id: user.id,
      email: user.email
    }
  end
end
