defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topic
  alias Discuss.Repo

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render(conn, :index, topics: topics)
   end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    changeset = Topic.changeset(%Topic{}, topic_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic #{post.title} posted successfully.")
        |> redirect(to: ~p"/topics")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render(:new, changeset: changeset)
    end
 end

 def show(conn, %{"id" => id}) do
  topic = Repo.get!(Topic, id)
  render(conn, :show, topic: topic)
end

 def edit(conn, %{"id" => id}) do
  topic = Repo.get!(Topic, id)
  changeset = Topic.changeset(topic)
  render(conn, :edit, topic: topic, changeset: changeset)
end

def update(conn, %{"id" => id, "topic" => topic_params}) do
  changeset = Repo.get!(Topic, id) |> Topic.changeset(topic_params)
    case Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: ~p"/topics/#{topic}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render(:edit, topic: Repo.get!(Topic,id) , changeset: changeset)
    end
end

def delete(conn, %{"id" => id}) do
  #topic = Repo.get!(Topic, id)
  #{:ok, _user} = Repo.delete!(topic)

  Repo.get!(Topic, id) |> Repo.delete!()
  conn
  |> put_flash(:info, "Topic deleted successfully.")
  |> redirect(to: ~p"/topics")
end

end
