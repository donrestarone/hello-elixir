defmodule Discuss.TopicController do
  #initialize/ setup controller to behave like a controller
  # equivalent to class inheritance.
  use Discuss.Web, :controller
  # use => alias Discuss.Topic 
  # if you want to reference Discuss.Topic as simply Topic
  alias Discuss.Topic 

  def new(conn, params) do
    # get the connection coming from the client. 
    # params 
    IO.puts "+++"
    IO.inspect conn
    IO.puts "+++"
    IO.inspect params

    # struct = %Discuss.Topic{}    
    # params = %{}
    # changeset = Discuss.Topic.changeset(struct, params)
    # shorthand 
    changeset = Topic.changeset(%Topic{}, %{})
  end
end