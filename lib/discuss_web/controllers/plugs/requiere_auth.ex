defmodule DiscussWeb.Plugs.RequiereAuth do
  import Plug.Conn
  import Phoenix.Controller
  use Phoenix.VerifiedRoutes, endpoint: DiscussWeb.Endpoint, router: DiscussWeb.Router

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: ~p"/topics")
      |> halt()
    end

  end
end
