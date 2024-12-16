defmodule Gaze.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text, null: false
      add :channel_id, references(:channels, on_delete: :nothing, type: :binary_id), null: false
      add :sent_by_user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps(type: :naive_datetime_usec)
    end

    create index(:messages, [:channel_id])
    create index(:messages, [:sent_by_user_id])
  end
end
