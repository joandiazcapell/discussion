defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel "comments:*", DiscussWeb.CommentsChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user} -> {:ok, assign(socket, :user, user)}
      {:error, _error} -> :error
    end

  end

  @impl true
  def id(_socket), do: nil
end
