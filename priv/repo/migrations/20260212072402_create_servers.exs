defmodule Parler.Repo.Migrations.CreateServers do
  use Ecto.Migration

  def change do
    create table(:servers, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuidv7()")
      add :name, :string
      add :description, :string
      add :slug, :string
      add :owner_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:servers, [:slug])

    create index(:servers, [:owner_id])
  end
end
