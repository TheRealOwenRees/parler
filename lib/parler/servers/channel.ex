defmodule Parler.Servers.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "channels" do
    field :name, :string
    field :description, :string

    belongs_to :server, Parler.Servers.Server, foreign_key: :server_id
    belongs_to :user, Parler.Accounts.User, foreign_key: :user_id
    has_many :messages, Parler.Messages.Message

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs, user_scope) do
    channel
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> put_change(:user_id, user_scope.user.id)
  end
end
