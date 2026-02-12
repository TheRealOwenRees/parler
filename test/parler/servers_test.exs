defmodule Parler.ServersTest do
  use Parler.DataCase

  alias Parler.Servers

  describe "servers" do
    alias Parler.Servers.Server

    import Parler.AccountsFixtures, only: [user_scope_fixture: 0]
    import Parler.ServersFixtures

    @invalid_attrs %{name: nil, description: nil, slug: nil}

    test "list_servers/1 returns all scoped servers" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      server = server_fixture(scope)
      other_server = server_fixture(other_scope)
      assert Servers.list_servers(scope) == [server]
      assert Servers.list_servers(other_scope) == [other_server]
    end

    test "get_server!/2 returns the server with given id" do
      scope = user_scope_fixture()
      server = server_fixture(scope)
      other_scope = user_scope_fixture()
      assert Servers.get_server!(scope, server.id) == server
      assert_raise Ecto.NoResultsError, fn -> Servers.get_server!(other_scope, server.id) end
    end

    test "create_server/2 with valid data creates a server" do
      valid_attrs = %{name: "some name", description: "some description", slug: "some slug"}
      scope = user_scope_fixture()

      assert {:ok, %Server{} = server} = Servers.create_server(scope, valid_attrs)
      assert server.name == "some name"
      assert server.description == "some description"
      assert server.slug == "some slug"
      assert server.user_id == scope.user.id
    end

    test "create_server/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Servers.create_server(scope, @invalid_attrs)
    end

    test "update_server/3 with valid data updates the server" do
      scope = user_scope_fixture()
      server = server_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description", slug: "some updated slug"}

      assert {:ok, %Server{} = server} = Servers.update_server(scope, server, update_attrs)
      assert server.name == "some updated name"
      assert server.description == "some updated description"
      assert server.slug == "some updated slug"
    end

    test "update_server/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      server = server_fixture(scope)

      assert_raise MatchError, fn ->
        Servers.update_server(other_scope, server, %{})
      end
    end

    test "update_server/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      server = server_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Servers.update_server(scope, server, @invalid_attrs)
      assert server == Servers.get_server!(scope, server.id)
    end

    test "delete_server/2 deletes the server" do
      scope = user_scope_fixture()
      server = server_fixture(scope)
      assert {:ok, %Server{}} = Servers.delete_server(scope, server)
      assert_raise Ecto.NoResultsError, fn -> Servers.get_server!(scope, server.id) end
    end

    test "delete_server/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      server = server_fixture(scope)
      assert_raise MatchError, fn -> Servers.delete_server(other_scope, server) end
    end

    test "change_server/2 returns a server changeset" do
      scope = user_scope_fixture()
      server = server_fixture(scope)
      assert %Ecto.Changeset{} = Servers.change_server(scope, server)
    end
  end

  describe "channels" do
    alias Parler.Servers.Channel

    import Parler.AccountsFixtures, only: [user_scope_fixture: 0]
    import Parler.ServersFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_channels/1 returns all scoped channels" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      channel = channel_fixture(scope)
      other_channel = channel_fixture(other_scope)
      assert Servers.list_channels(scope) == [channel]
      assert Servers.list_channels(other_scope) == [other_channel]
    end

    test "get_channel!/2 returns the channel with given id" do
      scope = user_scope_fixture()
      channel = channel_fixture(scope)
      other_scope = user_scope_fixture()
      assert Servers.get_channel!(scope, channel.id) == channel
      assert_raise Ecto.NoResultsError, fn -> Servers.get_channel!(other_scope, channel.id) end
    end

    test "create_channel/2 with valid data creates a channel" do
      valid_attrs = %{name: "some name", description: "some description"}
      scope = user_scope_fixture()

      assert {:ok, %Channel{} = channel} = Servers.create_channel(scope, valid_attrs)
      assert channel.name == "some name"
      assert channel.description == "some description"
      assert channel.user_id == scope.user.id
    end

    test "create_channel/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Servers.create_channel(scope, @invalid_attrs)
    end

    test "update_channel/3 with valid data updates the channel" do
      scope = user_scope_fixture()
      channel = channel_fixture(scope)
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Channel{} = channel} = Servers.update_channel(scope, channel, update_attrs)
      assert channel.name == "some updated name"
      assert channel.description == "some updated description"
    end

    test "update_channel/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      channel = channel_fixture(scope)

      assert_raise MatchError, fn ->
        Servers.update_channel(other_scope, channel, %{})
      end
    end

    test "update_channel/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      channel = channel_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Servers.update_channel(scope, channel, @invalid_attrs)
      assert channel == Servers.get_channel!(scope, channel.id)
    end

    test "delete_channel/2 deletes the channel" do
      scope = user_scope_fixture()
      channel = channel_fixture(scope)
      assert {:ok, %Channel{}} = Servers.delete_channel(scope, channel)
      assert_raise Ecto.NoResultsError, fn -> Servers.get_channel!(scope, channel.id) end
    end

    test "delete_channel/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      channel = channel_fixture(scope)
      assert_raise MatchError, fn -> Servers.delete_channel(other_scope, channel) end
    end

    test "change_channel/2 returns a channel changeset" do
      scope = user_scope_fixture()
      channel = channel_fixture(scope)
      assert %Ecto.Changeset{} = Servers.change_channel(scope, channel)
    end
  end
end
