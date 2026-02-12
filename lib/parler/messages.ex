defmodule Parler.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Parler.Repo

  alias Parler.Messages.Message
  alias Parler.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any message changes.

  The broadcasted messages match the pattern:

    * {:created, %Message{}}
    * {:updated, %Message{}}
    * {:deleted, %Message{}}

  """
  def subscribe_messages(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Parler.PubSub, "user:#{key}:messages")
  end

  defp broadcast_message(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Parler.PubSub, "user:#{key}:messages", message)
  end

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages(scope)
      [%Message{}, ...]

  """
  def list_messages(%Scope{} = scope) do
    Repo.all_by(Message, user_id: scope.user.id)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(scope, 123)
      %Message{}

      iex> get_message!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(%Scope{} = scope, id) do
    Repo.get_by!(Message, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(scope, %{field: value})
      {:ok, %Message{}}

      iex> create_message(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(%Scope{} = scope, attrs) do
    with {:ok, message = %Message{}} <-
           %Message{}
           |> Message.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_message(scope, {:created, message})
      {:ok, message}
    end
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(scope, message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(scope, message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Scope{} = scope, %Message{} = message, attrs) do
    true = message.user_id == scope.user.id

    with {:ok, message = %Message{}} <-
           message
           |> Message.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_message(scope, {:updated, message})
      {:ok, message}
    end
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(scope, message)
      {:ok, %Message{}}

      iex> delete_message(scope, message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Scope{} = scope, %Message{} = message) do
    true = message.user_id == scope.user.id

    with {:ok, message = %Message{}} <-
           Repo.delete(message) do
      broadcast_message(scope, {:deleted, message})
      {:ok, message}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(scope, message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Scope{} = scope, %Message{} = message, attrs \\ %{}) do
    true = message.user_id == scope.user.id

    Message.changeset(message, attrs, scope)
  end
end
