defmodule LabsEasy.Helpers.Response do
  def resp_clean(resp) when is_list(resp) do
    resp
    |> Enum.map(fn {k, v} ->
      case v do
        %{__meta__: _} -> {k, v |> Map.delete(:__meta__)}
        _any -> {k, v}
      end
    end)
    |> Enum.into(%{})
    |> Poison.encode!()
    |> Poison.decode!()
  end

  def resp_clean(%{__struct__: _} = resp) do
    struct_to_map(resp)
  end

  def changeset_error(%{errors: errors}) do
    Enum.map(errors, fn {k, v} -> {k, v |> elem(0)} end) |> Enum.into(%{})
  end

  defp struct_to_map(resp) do
    resp
    |> Map.from_struct()
    |> Map.delete(:__meta__)
  end
end
