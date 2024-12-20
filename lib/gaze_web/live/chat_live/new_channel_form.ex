defmodule GazeWeb.ChatLive.NewChannelForm do
  use GazeWeb, :live_component

  alias Gaze.Channels
  alias Gaze.Channels.Channel

  def mount(socket) do
    {:ok, put_form(socket)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.header>
        New Channel
      </.header>

      <.simple_form for={@form} phx-change="validate" phx-submit="submit" phx-target={@myself}>
        <.input field={@form[:name]} label="Name" autocomplete="off" />
        <:actions>
          <.button type="submit">Create Channel</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event("validate", %{"channel" => params}, socket) do
    changeset =
      %Channel{}
      |> Channel.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, put_form(socket, changeset)}
  end

  def handle_event("submit", %{"channel" => params}, socket) do
    case Channels.create_channel(params) do
      {:ok, channel} ->
        send(self(), {__MODULE__, {:create_channel, channel}})
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, put_form(socket, changeset)}
    end
  end

  def put_form(socket, value \\ %{}) do
    assign(socket, :form, to_form(value, as: :channel))
  end
end
