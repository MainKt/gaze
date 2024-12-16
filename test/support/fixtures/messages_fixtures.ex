defmodule Gaze.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Gaze.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> Gaze.Messages.create_message()

    message
  end
end
