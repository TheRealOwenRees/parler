defmodule Parler.ServersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parler.Servers` context.
  """

  @doc """
  Generate a unique server slug.
  """
  def unique_server_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a server.
  """
  def server_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name",
        slug: unique_server_slug()
      })

    {:ok, server} = Parler.Servers.create_server(scope, attrs)
    server
  end

  @doc """
  Generate a channel.
  """
  def channel_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        description: "some description",
        name: "some name"
      })

    {:ok, channel} = Parler.Servers.create_channel(scope, attrs)
    channel
  end
end
