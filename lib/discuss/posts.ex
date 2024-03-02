defmodule Discuss.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Posts.Topic
  alias Discuss.Posts.Comment

  @doc """
  Returns the list of topics.

  ## Examples

      iex> list_topics()
      [%Topic{}, ...]

  """
  def list_topics do
    Repo.all(Topic)
  end

  @doc """
  Gets a single topic.

  Raises if the Topic does not exist.

  ## Examples

      iex> get_topic!(123)
      %Topic{}

  """
  def get_topic!(id), do: Repo.get!(Topic, id)

  def get_topic_with_comments!(id) do
    Repo.get!(Topic,id)
    |> Repo.preload(comments: [:user])
  end


  @doc """
  Creates a topic.

  ## Examples

      iex> create_topic(%{field: value})
      {:ok, %Topic{}}

      iex> create_topic(%{field: bad_value})
      {:error, ...}

  """
  def create_topic(attrs) do
    attrs.user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(attrs.topic_params)
      |> Repo.insert()
  end

  @doc """
  Updates a topic.

  ## Examples

      iex> update_topic(topic, %{field: new_value})
      {:ok, %Topic{}}

      iex> update_topic(topic, %{field: bad_value})
      {:error, ...}

  """
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Topic.

  ## Examples

      iex> delete_topic(topic)
      {:ok, %Topic{}}

      iex> delete_topic(topic)
      {:error, ...}

  """
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc """
  Returns a data structure for tracking topic changes.

  ## Examples

      iex> change_topic(topic)
      %Todo{...}

  """
  def change_topic(%Topic{} = topic, attrs \\ %{}) do
    Topic.changeset(topic, attrs)
  end

  def create_comment(attrs) do
    attrs.topic
    |> Ecto.build_assoc(:comments, user: attrs.user)
    |> Comment.changeset(%{content: attrs.content})
    |> Repo.insert()
  end

end
