defmodule GazeWeb.ChatLive do
  use GazeWeb, :live_view

  import GazeWeb.ChatLive.Components

  def mount(_params, _session, socket) do
    channels = [
      %{name: "general", selected: false},
      %{name: "rules", selected: false},
      %{name: "linux", selected: true}
    ]

    socket =
      socket |> assign(channels: channels)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="flex">
      <.channels_list channels={@channels} />
      <.chat_section channel={(@channels |> Enum.find(& &1.selected)).name}>
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
