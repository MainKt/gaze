defmodule GazeWeb.ChatLive do
  use GazeWeb, :live_view

  import GazeWeb.ChatLive.Components

  alias Gaze.Channels

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(
        channels: Channels.list_channels(),
        selected_channel: Channels.get_one!()
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
    """
  end
end
