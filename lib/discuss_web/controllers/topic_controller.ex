defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Posts
  alias Discuss.Posts.Topic

  plug DiscussWeb.Plugs.RequiereAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    topics = Posts.list_topics()
    render(conn, :index, topics: topics)
  end

  def new(conn, _params) do
    changeset = Posts.change_topic(%Topic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    case Posts.create_topic(%{topic_params: topic_params, user: conn.assigns.user}) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic #{topic.title} posted successfully.")
        |> redirect(to: ~p"/topics")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Posts.get_topic!(id)
    render(conn, :show, topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Posts.get_topic!(id)
    changeset = Posts.change_topic(topic)
    render(conn, :edit, topic: topic, changeset: changeset)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    old_topic = Posts.get_topic!(id)

    case Posts.update_topic(old_topic, topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render(:edit, topic: old_topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    #topic = Repo.get!(Topic, id)
    #{:ok, _user} = Repo.delete!(topic)
    topic = Posts.get_topic!(id)
    {:ok, _topic} = Posts.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: ~p"/topics")
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn

    if Posts.get_topic!(topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot delete that")
      |> redirect(to: ~p"/topics")
      |> halt()
    end
  end

end
