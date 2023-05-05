defmodule StreamTest.ThingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `StreamTest.Things` context.
  """

  @doc """
  Generate a model.
  """
  def model_fixture(attrs \\ %{}) do
    {:ok, model} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> StreamTest.Things.create_model()

    model
  end
end
