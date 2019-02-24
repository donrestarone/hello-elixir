defmodule Discuss.Topic do
  # 'inherit' from model 
  use Discuss.Web, :model

  # schema for title as string datatype
  schema "topics" do
    field :title, :string
  end

  # changeset for validation
  # define params default value
  def changeset(struct, params \\ %{}) do
    # record in the database/ params is the properties coming in, matches the object attributes. 
    # casted and compared.
    # also used to save stuff to the database. Changeset gets saved.
    struct 
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end