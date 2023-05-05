defmodule StreamTestWeb.ModelLive.Show do
  use StreamTestWeb, :live_view

  alias StreamTest.Things

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:model, Things.get_model!(id))}
  end

  defp page_title(:show), do: "Show Model"
  defp page_title(:edit), do: "Edit Model"
end