defmodule StreamTest.ThingsTest do
  use StreamTest.DataCase

  alias StreamTest.Things

  describe "models" do
    alias StreamTest.Things.Model

    import StreamTest.ThingsFixtures

    @invalid_attrs %{content: nil}

    test "list_models/0 returns all models" do
      model = model_fixture()
      assert Things.list_models() == [model]
    end

    test "get_model!/1 returns the model with given id" do
      model = model_fixture()
      assert Things.get_model!(model.id) == model
    end

    test "create_model/1 with valid data creates a model" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Model{} = model} = Things.create_model(valid_attrs)
      assert model.content == "some content"
    end

    test "create_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Things.create_model(@invalid_attrs)
    end

    test "update_model/2 with valid data updates the model" do
      model = model_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Model{} = model} = Things.update_model(model, update_attrs)
      assert model.content == "some updated content"
    end

    test "update_model/2 with invalid data returns error changeset" do
      model = model_fixture()
      assert {:error, %Ecto.Changeset{}} = Things.update_model(model, @invalid_attrs)
      assert model == Things.get_model!(model.id)
    end

    test "delete_model/1 deletes the model" do
      model = model_fixture()
      assert {:ok, %Model{}} = Things.delete_model(model)
      assert_raise Ecto.NoResultsError, fn -> Things.get_model!(model.id) end
    end

    test "change_model/1 returns a model changeset" do
      model = model_fixture()
      assert %Ecto.Changeset{} = Things.change_model(model)
    end
  end
end
