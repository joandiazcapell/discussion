defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn

  alias Discuss.Accounts

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Accounts.get_user!(user_id) ->
        conn
        |> assign(:user, user)
        |> assign(:user_signed_in?, true)
        # conn.assigns.user => user struct
      true ->
        conn
        |> assign(:user, nil)
        |> assign(:user_signed_in?, false)
    end
  end

end
