defmodule Discuss.Posts.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.Accounts.User
    has_many :comments, Discuss.Posts.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end

end
