defmodule Discuss.TopicController do
  #initialize/ setup controller to behave like a controller
  # equivalent to class inheritance.
  use Discuss.Web, :controller
  # use => alias Discuss.Topic 
  # if you want to reference Discuss.Topic as simply Topic
  alias Discuss.Topic 

  def new(conn, _params) do
    # # get the connection coming from the client. 
    # # params 
    # IO.puts "+++"
    # IO.inspect conn
    # IO.puts "+++"
    # IO.inspect params

    # struct = %Discuss.Topic{}    
    # params = %{}
    # changeset = Discuss.Topic.changeset(struct, params)
    # shorthand 
    changeset = Topic.changeset(%Topic{}, %{})

    # pass changeset instance to the view as @changeset
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    # pattern match to get the topic object out of params
    # pass a new topic struct/object to the changeset for validation
    changeset = Topic.changeset(%Topic{}, topic)
    # insert changeset into database
    case Repo.insert(changeset) do
      # case statement for the return value of Repo.insert
      # Repo.insert returns a tuple 
      {:ok, _topic} -> 
        conn 
        |> put_flash(:info, "Topic Created")
        # redirect to index path => specify to, pass connection and specify the controller action
        |> redirect(to: topic_path(conn, :index))
      # if it doesnt save, we re-render the new view.
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    # to get all the topics from the database
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    # grab query string id params, as topic_id
    # then hit the database and fetch the topic by id
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    # old_topic = Repo.get(Topic, topic_id)
    # changeset = Topic.changeset(old_topic, topic)
    # short hand for the above ^^ with pipe syntax
    old_topic = Repo.get(Topic, topic_id)
    # pass the old topic, and the new changes to create a changeset to be inserted into the database
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end
end