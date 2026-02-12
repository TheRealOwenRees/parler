defmodule Parler.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuidv7()")
      add :body, :text
      add :user, references(:users, on_delete: :nothing, type: :binary_id)
      add :channel, references(:channels, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:user_id])

    create index(:messages, [:user])
    create index(:messages, [:channel])
  end
end
