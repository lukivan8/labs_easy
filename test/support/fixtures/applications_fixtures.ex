defmodule LabsEasy.ApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LabsEasy.Applications` context.
  """

  @doc """
  Generate a request.
  """
  def request_fixture(attrs \\ %{}) do
    {:ok, request} =
      attrs
      |> Enum.into(%{
        attachment: "some attachment",
        date: ~D[2024-06-03],
        contact: "some email",
        name: "some name",
        subject: "some subject",
        type: 42
      })
      |> LabsEasy.Applications.create_request()

    request
  end

  @doc """
  Generate a subject.
  """
  def subject_fixture(attrs \\ %{}) do
    {:ok, subject} =
      attrs
      |> Enum.into(%{
        course: 42,
        name: "some name"
      })
      |> LabsEasy.Applications.create_subject()

    subject
  end
end
