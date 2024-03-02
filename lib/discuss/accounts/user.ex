defmodule Discuss.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:name, :email]}

  schema "users" do
    field :name, :string
    field :age, :integer
    field :token, :string
    field :provider, :string
    field :email, :string
    has_many :topics, Discuss.Posts.Topic
    has_many :comments, Discuss.Posts.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:name, :age, :email, :provider, :token])
    |> validate_required([:name, :age])
  end
end
