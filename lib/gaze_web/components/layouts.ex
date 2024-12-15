defmodule GazeWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use GazeWeb, :controller` and
  `use GazeWeb, :live_view`.
  """
  use GazeWeb, :html

  embed_templates "layouts/*"

  def side_strip(assigns) do
    ~H"""
    <div class="flex h-screen w-16 flex-col justify-between border-e bg-white">
      <div class="px-2">
        <.guilds_list />
      </div>

      <div class="sticky inset-x-0 bottom-0 border-t border-gray-100 bg-white p-2">
        <.link
          navigate="/settings"
          class="group relative flex w-full justify-center rounded-lg px-2 py-1.5 text-sm text-gray-500 hover:bg-gray-50 hover:text-gray-700"
        >
          <.icon name="hero-cog-6-tooth-mini" />
          <span class="invisible absolute start-full top-1/2 ms-4 -translate-y-1/2 rounded bg-gray-900 px-2 py-1.5 text-xs font-medium text-white group-hover:visible">
            Settings
          </span>
        </.link>
      </div>
    </div>
    """
  end

  def guilds_list(assigns) do
    selected = true

    ~H"""
    <ul class="space-y-1 border-t border-gray-100 pt-4">
      <li>
        <.link
          href="#"
          class={[
            "group relative flex justify-center rounded px-2 py-1.5 text-gray-500 hover:bg-gray-50 hover:text-gray-600",
            selected && "!bg-gray-200 !text-gray-700"
          ]}
        >
          <.icon name="hero-home-solid" />
          <span class="invisible absolute start-full top-1/2 ms-4 -translate-y-1/2 rounded bg-gray-900 px-2 py-1.5 text-xs font-medium text-white group-hover:visible">
            Home
          </span>
        </.link>
      </li>
    </ul>
    """
  end
end
