defmodule ParlerWeb.PageController do
  use ParlerWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
