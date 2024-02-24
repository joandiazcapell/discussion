defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller

  alias Discuss.Accounts

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider_params}) do
    user_params = %{name: auth.info.name, age: 0, email: auth.info.email, provider: provider_params, token: auth.credentials.token}

    sigin(conn,user_params)

  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: ~p"/topics")
  end

  defp sigin(conn,user_params) do
    case insert_or_update_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: ~p"/topics")
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error sigin in")
        |> redirect(to: ~p"/topics")
    end

  end

  defp insert_or_update_user(user_params) do
    case Accounts.get_user_by_email(user_params.email) do
      nil ->
        Accounts.create_user(user_params)
      user ->
        {:ok, user}
    end
  end

end
