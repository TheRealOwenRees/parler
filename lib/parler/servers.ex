defmodule Parler.Servers do
  @moduledoc """
  The Servers context.
  """

  import Ecto.Query, warn: false
  alias Parler.Repo

  alias Parler.Servers.Server
  alias Parler.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any server changes.

  The broadcasted messages match the pattern:

    * {:created, %Server{}}
    * {:updated, %Server{}}
    * {:deleted, %Server{}}

  """
  def subscribe_servers(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Parler.PubSub, "user:#{key}:servers")
  end

  defp broadcast_server(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Parler.PubSub, "user:#{key}:servers", message)
  end

  @doc """
  Returns the list of servers.

  ## Examples

      iex> list_servers(scope)
      [%Server{}, ...]

  """
  def list_servers(%Scope{} = scope) do
    Repo.all_by(Server, owner_id: scope.user.id)
  end

  @doc """
  Gets a single server.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server!(scope, 123)
      %Server{}

      iex> get_server!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_server!(%Scope{} = scope, id) do
    Repo.get_by!(Server, id: id, owner_id: scope.user.id)
  end

  @doc """
  Creates a server.

  ## Examples

      iex> create_server(scope, %{field: value})
      {:ok, %Server{}}

      iex> create_server(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_server(%Scope{} = scope, attrs) do
    with {:ok, server = %Server{}} <-
           %Server{}
           |> Server.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_server(scope, {:created, server})
      {:ok, server}
    end
  end

  @doc """
  Updates a server.

  ## Examples

      iex> update_server(scope, server, %{field: new_value})
      {:ok, %Server{}}

      iex> update_server(scope, server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_server(%Scope{} = scope, %Server{} = server, attrs) do
    true = server.owner_id == scope.user.id

    with {:ok, server = %Server{}} <-
           server
           |> Server.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_server(scope, {:updated, server})
      {:ok, server}
    end
  end

  @doc """
  Deletes a server.

  ## Examples

      iex> delete_server(scope, server)
      {:ok, %Server{}}

      iex> delete_server(scope, server)
      {:error, %Ecto.Changeset{}}

  """
  def delete_server(%Scope{} = scope, %Server{} = server) do
    true = server.owner_id == scope.user.id

    with {:ok, server = %Server{}} <-
           Repo.delete(server) do
      broadcast_server(scope, {:deleted, server})
      {:ok, server}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking server changes.

  ## Examples

      iex> change_server(scope, server)
      %Ecto.Changeset{data: %Server{}}

  """
  def change_server(%Scope{} = scope, %Server{} = server, attrs \\ %{}) do
    true = server.owner_id == scope.user.id

    Server.changeset(server, attrs, scope)
  end

  alias Parler.Servers.Channel
  alias Parler.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any channel changes.

  The broadcasted messages match the pattern:

    * {:created, %Channel{}}
    * {:updated, %Channel{}}
    * {:deleted, %Channel{}}

  """
  def subscribe_channels(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Parler.PubSub, "user:#{key}:channels")
  end

  defp broadcast_channel(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Parler.PubSub, "user:#{key}:channels", message)
  end

  @doc """
  Returns the list of channels.

  ## Examples

      iex> list_channels(scope)
      [%Channel{}, ...]

  """
  def list_channels(%Scope{} = scope) do
    Repo.all_by(Channel, user_id: scope.user.id)
  end

  @doc """
  Gets a single channel.

  Raises `Ecto.NoResultsError` if the Channel does not exist.

  ## Examples

      iex> get_channel!(scope, 123)
      %Channel{}

      iex> get_channel!(scope, 456)
      ** (Ecto.NoResultsError)

  """
  def get_channel!(%Scope{} = scope, id) do
    Repo.get_by!(Channel, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a channel.

  ## Examples

      iex> create_channel(scope, %{field: value})
      {:ok, %Channel{}}

      iex> create_channel(scope, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_channel(%Scope{} = scope, attrs) do
    with {:ok, channel = %Channel{}} <-
           %Channel{}
           |> Channel.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_channel(scope, {:created, channel})
      {:ok, channel}
    end
  end

  @doc """
  Updates a channel.

  ## Examples

      iex> update_channel(scope, channel, %{field: new_value})
      {:ok, %Channel{}}

      iex> update_channel(scope, channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_channel(%Scope{} = scope, %Channel{} = channel, attrs) do
    true = channel.user_id == scope.user.id

    with {:ok, channel = %Channel{}} <-
           channel
           |> Channel.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_channel(scope, {:updated, channel})
      {:ok, channel}
    end
  end

  @doc """
  Deletes a channel.

  ## Examples

      iex> delete_channel(scope, channel)
      {:ok, %Channel{}}

      iex> delete_channel(scope, channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_channel(%Scope{} = scope, %Channel{} = channel) do
    true = channel.user_id == scope.user.id

    with {:ok, channel = %Channel{}} <-
           Repo.delete(channel) do
      broadcast_channel(scope, {:deleted, channel})
      {:ok, channel}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking channel changes.

  ## Examples

      iex> change_channel(scope, channel)
      %Ecto.Changeset{data: %Channel{}}

  """
  def change_channel(%Scope{} = scope, %Channel{} = channel, attrs \\ %{}) do
    true = channel.user_id == scope.user.id

    Channel.changeset(channel, attrs, scope)
  end
end
