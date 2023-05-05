defmodule StreamTest.Things.Model do
  use Ecto.Schema
  import Ecto.Changeset

  schema "models" do
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(model, attrs) do
    model
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
