defmodule StreamTestWeb.ModelLive.FormComponent do
  use StreamTestWeb, :live_component

  alias StreamTest.Things

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage model records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="model-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Model</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{model: model} = assigns, socket) do
    changeset = Things.change_model(model)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"model" => model_params}, socket) do
    changeset =
      socket.assigns.model
      |> Things.change_model(model_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"model" => model_params}, socket) do
    save_model(socket, socket.assigns.action, model_params)
  end

  defp save_model(socket, :edit, model_params) do
    case Things.update_model(socket.assigns.model, model_params) do
      {:ok, model} ->
        notify_parent({:saved, model})

        {:noreply,
         socket
         |> put_flash(:info, "Model updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_model(socket, :new, model_params) do
    case Things.create_model(model_params) do
      {:ok, model} ->
        notify_parent({:saved, model})

        {:noreply,
         socket
         |> put_flash(:info, "Model created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
