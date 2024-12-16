defmodule GazeWeb.ChatLive do
  use GazeWeb, :live_view

  import GazeWeb.ChatLive.Components

  alias Gaze.Channels

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

    socket = socket
    |> assign(
      selected_channel: selected_channel,
      channels: Channels.list_channels(),
      modal: nil
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

  def render(assigns) do
    ~H"""
    <div class="flex">
      <.channels_list channels={@channels} selected={@selected_channel} />

      <%= if @selected_channel do %>
        <.chat_section channel={@selected_channel}>
          <.messages>
            <.message
              online={true}
              text="How are y'all doing?"
              user="Main.kt"
              time="5:30"
              compact={true}
            />
            <.message online={true} text="I'm Main.kt" user="Main.kt" time="5:30" compact={true} />
            <.message online={false} text="Howdy?" user="Main.kt" time="5:30" compact={false} />
          </.messages>
          <.input type="textarea" name="" value="" placeholder="Type a message" autofocus />
        </.chat_section>
      <% else %>
        <div class="my-auto mx-auto px-4">
          <img class="max-w-40" src={~p"/images/logo.svg"} />
        </div>
      <% end %>
    </div>

    <.modal :if={@modal == :new_channel} id="new_channel_modal" show on_cancel={JS.push("hide_modal")}>
      <.live_component
        id="new_channel_form"
        module={__MODULE__.NewChannelForm}
      />
    </.modal>
    """
  end

  def handle_event("add_new_channel", _params, socket) do
    {:noreply, socket |> assign(:modal, :new_channel)}
  end

  def handle_event("hide_modal", _params, socket) do
    {:noreply, assign(socket, :modal, nil)}
  end


  def handle_info({__MODULE__.NewChannelForm, {:create_channel, channel}}, socket) do
    socket = socket
    |> assign(model: nil, channels: Channels.list_channels())
    |> push_patch(to: ~p"/chat/#{channel.name}")
    {:noreply, socket}
  end
end
