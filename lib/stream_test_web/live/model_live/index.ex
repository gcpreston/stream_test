defmodule StreamTestWeb.ModelLive.Index do
  use StreamTestWeb, :live_view

  alias StreamTest.Things
  alias StreamTest.Things.Model

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :models, Things.list_models())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Model")
    |> assign(:model, Things.get_model!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Model")
    |> assign(:model, %Model{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Models")
    |> assign(:model, nil)
  end

  @impl true
  def handle_info({StreamTestWeb.ModelLive.FormComponent, {:saved, model}}, socket) do
    {:noreply, stream_insert(socket, :models, model)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    model = Things.get_model!(id)
    {:ok, _} = Things.delete_model(model)

    {:noreply, stream_delete(socket, :models, model)}
  end
end
