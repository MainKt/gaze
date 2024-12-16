defmodule Gaze.ChannelsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gaze.Channels` context.
  """

  @doc """
  Generate a unique channel name.
  """
  def unique_channel_name, do: "some name#{System.unique_integer([:positive])}"

  @doc """
  Generate a channel.
  """
  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(%{
        name: unique_channel_name()
      })
      |> Gaze.Channels.create_channel()

    channel
  end
end
