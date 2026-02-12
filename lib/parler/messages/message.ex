defmodule Parler.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :body, :string

    belongs_to :channel, Parler.Servers.Channel, foreign_key: :channel_id
    belongs_to :user, Parler.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs, user_scope) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> put_change(:user_id, user_scope.user.id)
  end
end
