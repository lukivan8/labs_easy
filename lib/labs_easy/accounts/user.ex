defmodule LabsEasy.Accounts.User do
  alias LabsEasy.Repo
  alias MyApp.Services.Authenticator
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :auth_tokens, LabsEasy.Accounts.AuthToken
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil ->
        changeset

      pass ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
    end
  end

  def create_user(email, password) do
    %__MODULE__{}
    |> changeset(%{email: email, password: password})
    |> Repo.insert()
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(Repo.get_by(__MODULE__, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))

      err ->
        err
    end
  end

  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(LabsEasy.Accounts.AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end

      error ->
        error |> IO.inspect()
    end
  end
end
