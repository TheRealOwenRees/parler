defmodule Parler.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parler.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        body: "some body"
      })

    {:ok, message} = Parler.Messages.create_message(scope, attrs)
    message
  end
end
