defmodule GazeWeb.ChatLive do
  use GazeWeb, :live_view

  import GazeWeb.ChatLive.Components

  alias Gaze.Channels
  alias Gaze.Messages
  alias Gaze.Messages.Message

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        channels: Channels.list_channels(),
        modal: nil
      )

    {:ok, socket}
  end

  def handle_params(%{"name" => name}, _uri, socket) do
    selected_channel = Channels.get_channel_by_name!(name)
    messages = Messages.list(selected_channel)

    socket =
      socket
      |> assign(
        modal: nil,
        selected_channel: selected_channel,
        channels: Channels.list_channels(),
        messages: messages
      )

    {:noreply, socket}
  end

  def handle_params(_, _, socket) do
    socket =
      assign(
        socket,
        selected_channel: nil,
        channels: Channels.list_channels(),
        modal: nil
      )

    {:noreply, socket}
  end

  def group_messages(messages) do
    messages
    |> Enum.chunk_by(& &1.sent_by_user_id)
    |> Enum.flat_map(fn chunk ->
      chunk
      |> Enum.map(&Map.put(&1, :compact, true))
      |> List.update_at(-1, &Map.put(&1, :compact, false))
    end)
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <.channels_list channels={@channels} selected={@selected_channel} />

      <%= if @selected_channel do %>
      <.chat_section channel={@selected_channel}>
        <.messages>
          <.message :for={message <- @messages |> group_messages()}
            online={true}
            text={message.text}
            user={message.sent_by_user}
            time={Message.show_time(message, @current_user.time_zone)}
            compact={message.compact}
          />
        </.messages>

        <.live_component
          id={"chat_component_#{@selected_channel.id}"}
          module={__MODULE__.ChatForm}
          current_user={@current_user}
          current_channel={@selected_channel}
        />

      </.chat_section>
      <% else %>
      <div class="my-auto mx-auto px-4">
        <img class="max-w-40" src={~p"/images/logo.svg"} />
      </div>
      <% end %>
    </div>

    <.modal :if={@modal == :new_channel} id="new_channel_modal" show on_cancel={JS.push("hide_modal")}>
      <.live_component id="new_channel_form" module={__MODULE__.NewChannelForm} />
    </.modal>
    """
  end

  def handle_event("add_new_channel", _params, socket) do
    {:noreply, socket |> assign(:modal, :new_channel)}
  end

  def handle_event("hide_modal", _params, socket) do
    {:noreply, assign(socket, :modal, nil)}
  end

  def handle_event("validate", %{"chat" => params}, socket) do
    changeset =
      %Message{}
      |> Message.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, put_form(socket, changeset)}
  end

  def handle_event("submit", %{"channel" => params}, socket) do
    case Messages.create_message(params) do
      {:ok, _message} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, put_form(socket, changeset)}
    end
  end

  def put_form(socket, value \\ %{}) do
    assign(socket, :form, to_form(value, as: :chat))
  end

  def handle_info({__MODULE__.NewChannelForm, {:create_channel, channel}}, socket) do
    socket =
      socket
      |> assign(model: nil, channels: Channels.list_channels())
      |> push_patch(to: ~p"/chat/#{channel.name}")

    {:noreply, socket}
  end

  def handle_info({__MODULE__.ChatForm, :new_message}, socket) do
    messages = Messages.list(socket.assigns.selected_channel)
    socket =
      socket
      |> assign(model: nil, messages: messages)

    {:noreply, socket}
  end
end
