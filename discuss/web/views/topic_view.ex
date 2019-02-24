defmodule Discuss.TopicView do
  # connects with the topic controller to render views
  use Discuss.Web, :view
  
  alias Discuss.Topic 

  def new(conn, params) do
    changeset  = Topic.changeset(%Topic{}, %{})
  end
end