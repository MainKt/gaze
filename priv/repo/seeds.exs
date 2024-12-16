# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gaze.Repo.insert!(%Gaze.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

["general", "gaming", "linux"]
|> Stream.map(&%{name: &1})
|> Enum.map(&Gaze.Channels.create_channel!/1)
