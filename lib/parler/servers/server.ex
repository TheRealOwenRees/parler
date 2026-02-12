defmodule Parler.Servers.Server do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "servers" do
    field :name, :string
    field :description, :string
    field :slug, :string
    field :owner_id, :binary_id
    field :user_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(server, attrs, user_scope) do
    server
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description, :slug])
    |> unique_constraint(:slug)
    |> put_change(:user_id, user_scope.user.id)
  end
end
