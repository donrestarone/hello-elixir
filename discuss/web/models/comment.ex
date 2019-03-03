defmodule Discuss.Comment do 
  use Discuss.Web, :model
  # json serializer 
  @derive {Poison.Encoder, only: [:content, :user_id, :topic_id]}

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.User
    belongs_to :topic, Discuss.Topic
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end
end