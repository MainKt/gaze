defmodule GazeWeb.ChatLive.ChatForm do
  use GazeWeb, :live_component

  alias Gaze.Messages
  alias Gaze.Messages.Message

  def render(assigns) do
    ~H"""
    <div>
      <.form
        phx-change="validate"
        phx-target={@myself}
        phx-submit="submit"
        for={@form}>
        <.input
          type="text"
          field={@form[:text]}
          placeholder="Type a message"
          autofocus
        />
      </.form>
    </div>
    """
  end

  def mount(socket) do
    {:ok, handle_form(socket)}
  end

  def handle_event("validate", %{"chat" => params}, socket) do
    {:noreply, handle_form(socket, params, :validate)}
  end

  def handle_event("submit", %{"chat" => params}, socket) do
    case Ecto.Changeset.apply_action(changeset(params), :submit) do
      {:ok, attrs} ->
        Messages.send!(socket.assigns.current_channel, socket.assigns.current_user, attrs)
        send(self(), {__MODULE__, :new_message})
        {:noreply, socket |> handle_form()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, put_form(socket, changeset)}
    end
  end

  ## Helpers

  def handle_form(socket, params \\ %{}, action \\ nil) do
    changeset =
      params
      |> changeset()
      |> Map.put(:action, action)

    put_form(socket, changeset)
  end

  def put_form(socket, value \\ %{}) do
    assign(socket, :form, to_form(value, as: :chat))
  end

  def changeset(params) do
    import Ecto.Changeset

    {%{}, %{text: :string}}
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
