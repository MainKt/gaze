defmodule GazeWeb.ChatLive do
  use GazeWeb, :live_view

  import GazeWeb.ChatLive.Components

  alias Gaze.Channels

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        channels: Channels.list_channels(),
        selected_channel: Channels.get_one!(),
        modal: nil
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <.channels_list channels={@channels} selected={@selected_channel} />
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


  def handle_info({__MODULE__.NewChannelForm, :create_channel}, socket) do
    {:noreply, socket |> assign(modal: nil, channels: Channels.list_channels())}
  end
end
