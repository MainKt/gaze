defmodule GazeWeb.ChatLive.Components do
  use GazeWeb, :html

  slot :inner_block
  attr :channel, :string, required: true

  def chat_section(assigns) do
    ~H"""
    <div class="flex h-screen flex-1 flex-col bg-white">
      <.header class="px-4 py-3 border-b border-gray-200">
        <.icon name="hero-hashtag-micro" /> {@channel.name}
      </.header>
      <div class="px-4 pb-4 flex-1 flex flex-col overflow-auto">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :channels, :any, default: []
  attr :selected, :string

  def channels_list(assigns) do
    ~H"""
    <div class="flex h-screen flex-col border-e bg-white min-w-64">
      <.header class="px-4 py-3 border-b border-gray-200">Home</.header>
      <section class="px-2 my-4 space-y-1 flex flex-col overflow-auto">
        <ul class="flex-1 overflow-y-scroll no-scrollbar">
          <li :for={channel <- @channels}>
            <.link
              patch={"/chat/#{channel.name}"}
              class={[
                "block rounded-lg px-4 py-2 text-sm font-medium text-gray-700",
                channel == @selected && "!bg-gray-200",
                "hover:bg-gray-100"
              ]}
            >
              <.icon name="hero-hashtag-micro" /> {channel.name}
            </.link>
          </li>
        </ul>

        <div class="border-t" />

        <.link
          phx-click="add_new_channel"
          class={[
            "block rounded-lg px-4 py-2",
            " text-sm font-medium text-gray-700 text-center",
            "bg-gray-50 hover:bg-gray-100",
            " flex justify-center items-center"
          ]}
        >
          <.icon name="hero-plus-mini" />
          <p>Add channel</p>
        </.link>
      </section>
    </div>
    """
  end

  slot :inner_block, required: true

  def messages(assigns) do
    ~H"""
    <div class="flex-1 flex flex-col-reverse py-4 overflow-y-scroll no-scrollbar">
      {render_slot(@inner_block)}
    </div>
    """
  end

  attr :user, :any, required: true
  attr :size, :atom, values: [:xs, :md]
  attr :class, :string, default: nil
  attr :display_color, :string, default: "dodgerblue"
  attr :online, :boolean, default: nil

  def user_profile(assigns) do
    {size_class, indicator_class} =
      case assigns.size do
        :xs -> {"size-4 rounded", "size-1.5"}
        :md -> {"size-8 rounded-lg", "size-2"}
      end

    assigns = assign(assigns, size_class: size_class, indicator_class: indicator_class)

    ~H"""
    <div style={"background-color: #{@display_color};"} class={["relative", @size_class, @class]}>
      <div
        :if={@online != nil}
        class={[
          "absolute -bottom-px -right-0.5 rounded-full ring-2 ring-black",
          @indicator_class,
          if(@online == true, do: "bg-emerald-500"),
          if(@online == false, do: "bg-gray-300")
        ]}
      />
    </div>
    """
  end

  attr :user, :string, required: true
  attr :display_color, :string, default: "dodgerblue"
  attr :online, :boolean, required: true
  attr :time, :string, required: true
  attr :text, :string, required: true
  attr :compact, :boolean, required: true
  attr :on_delete, JS, default: nil

  def message(%{compact: true} = assigns) do
    ~H"""
    <div class="relative flex gap-2 hover:bg-gray-100 px-4 group">
      <div class="w-8 flex items-start justify-end pt-0.5 invisible group-hover:visible">
        <span class="text-xs text-black">
          {@time}
        </span>
      </div>
      <div class="flex-1">
        <p class="text-sm text-gray-800 whitespace-pre-wrap">{@text}</p>
      </div>
    </div>
    """
  end

  def message(assigns) do
    ~H"""
    <div class="relative flex gap-2 hover:bg-gray-100 px-4 pt-2 group">
      <.user_profile
        user={@user}
        size={:md}
        class="mt-1"
        online={@online}
        display_color={@display_color}
      />
      <div class="flex-1">
        <div class="space-x-1 leading-none">
          <span class="text-sm font-bold">{@user}</span>
          <span class="text-xs">{@time}</span>
        </div>
        <div class="flex-1">
          <p class="text-sm text-gray-800 whitespace-pre-wrap">{@text}</p>
        </div>
      </div>
    </div>
    """
  end
end
