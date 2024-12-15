defmodule GazeWeb.ChatLive do
  use GazeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>Chat</.header>
    """
  end
end
