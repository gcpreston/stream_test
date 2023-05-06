# IDEA
# - Cuberacer user_rounds stream works when initialized for current user
# - Does not work when initialized as part of a parent stream (or just any loop?)

defmodule StreamTestWeb.AssignLive do
  use StreamTestWeb, :live_view

  ## Models

  defmodule Thing do
    defstruct [:id, :text]

    def new(text) do
      %__MODULE__{id: Ecto.UUID.generate(), text: text}
    end
  end

  defmodule ThingCollection do
    defstruct [:id, :things]

    def new(things) when is_list(things) do
      %__MODULE__{id: Ecto.UUID.generate(), things: things}
    end
  end

  ## Mount + Render

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :thing_collections, [])}
  end

  def render(assigns) do
    ~H"""
    <div id="thing_collections" class="flex flex-row" phx-update="stream">
      <div :for={collection <- @thing_collections} id={"collection-#{collection.id}"}>
        <.display_thing_collection
          collection={collection}
          stream={@streams[collection_id_to_stream_name(collection.id)]}
        />
      </div>
    </div>
    <.button phx-click="new-thing-collection">New thing collection</.button>
    """
  end

  ## Callbacks

  def handle_event("new-thing-collection", _params, socket) do
    new_collection = ThingCollection.new([])

    {:noreply,
      socket
      |> assign(:thing_collections, [new_collection | socket.assigns.thing_collections])
      |> stream(collection_id_to_stream_name(new_collection.id), new_collection.things)}
  end

  def handle_event("new-thing", %{"collection" => collection_id}, socket) do
    {:noreply,
      stream_insert(
        socket,
        collection_id_to_stream_name(collection_id),
        Thing.new("hello world")
      )}
  end

  def handle_event("delete-thing", %{"collection" => collection_id, "thing" => thing_id}, socket) do

    {:noreply, stream_delete(socket, collection_id_to_stream_name(collection_id), %Thing{id: thing_id})}
  end

  ## Helpers

  # Functions

  defp collection_id_to_stream_name(collection_id) do
    "thing_collection-#{collection_id}"
  end

  # Components

  attr :collection, :any, doc: "The ThingCollection to display"
  attr :stream, :any, doc: "The stream of Things for this collection"

  defp display_thing_collection(assigns) do
    ~H"""
    <div id={"things-for-collection-#{@collection.id}"} phx-update="stream" class="border">
      <div
        :for={{dom_id, thing} <- @stream}
        id={dom_id}
        phx-click="delete-thing"
        phx-value-collection={@collection.id}
        phx-value-thing={thing.id}
      >
        <span><%= thing.text %></span>
      </div>
    </div>
    <.button phx-click="new-thing" phx-value-collection={@collection.id}>New thing</.button>
    """
  end
end
